require File.dirname(__FILE__) + '/../lib/frienda/frienda_helper.rb'
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/dot'
require 'yaml'
require File.dirname(__FILE__) + '/../lib/frienda/friend.rb'
require File.dirname(__FILE__) + '/../lib/frienda/rgl_dot_ext.rb'
require 'net/http'

# load dumped friend graph from file
def load_graph(graph_file)
  graph_objects = YAML.load_file(graph_file)
  vertices = graph_objects[:vertices]
  edges = graph_objects[:edges]

  g = RGL::AdjacencyGraph.new
  LOGGER.info "Importing friend vertex and edges from graph file."
  for v in vertices
    LOGGER.debug "Import vertex #{v}"
    g.add_vertex(v)
  end
  for edge in edges
    LOGGER.debug "Import edge #{edge.source}--#{edge.target}"
    g.add_edge(edge.source, edge.target)
  end

  # remove vertices whose out degrees are less than 2
  g.vertices.each do |v|
    g.remove_vertex(v) if g.out_degree(v) < 2
  end
  return g
end

def build_avatar_map(g)
  map = {}
  g.vertices.each {|v| map[v.uid] = v.avatar}
  map
end

# download avatar for each vertex in graph g and save avatar to avatar_dir
def download_avatars(g, avatar_dir)
  LOGGER.info "Downloading friends' avatars to #{avatar_dir} directory."
  FileUtils.mkdir(avatar_dir) unless File.exist?(avatar_dir)
  for friend in g.vertices
    # avatar is saved to report/avatars/name.ext
    avatar_file = File.join(avatar_dir, "#{friend.uid}.#{friend.avatar[-3, 3]}")
    LOGGER.info "Download avatar file to #{avatar_file}"
    res = Net::HTTP.get_response(URI.parse(friend.avatar))
    File.open(avatar_file, 'w') {|f| f.write(res.body)}
  end
end

# generate SVG graph from dot file
def generate_image_from_dot(image_name, format)
  LOGGER.info "Generating #{image_name}.#{format} from dot file..."
  dot_bin = File.join(CONFIG['graphviz_bin_dir'], 'dot')
  system "#{dot_bin} report/#{image_name}.dot -T#{format} -o report/#{image_name}.#{format}"
  LOGGER.info "Friends #{image_name}.#{format} image is generated in report directory."
end

def write_dot_file(g, dot_file)
  LOGGER.info "Generating simple dot file from friends graph..."
  dot_graph = g.to_dot_graph.to_s
  File.open(dot_file, 'w') do |f|
    f.write("graph friendsGraph {\n")
    f.write(dot_graph) 
    f.write("\n}")
  end
  LOGGER.info "Graphviz simple dot file is saved to #{dot_file}."
end

def write_complex_dot_file(g, avatar_dir, dot_file)
  LOGGER.info "Generating dot file with avatars from friends graph..."
  dot_graph = g.to_complex_dot_graph({'shapefile' => File.expand_path(avatar_dir)}).to_s
  File.open(dot_file, 'w') do |f|
    f.write("graph friendsGraph {\n")
    f.write(dot_graph) 
    f.write("\n}")
  end
  LOGGER.info "Graphviz dot file with avatars is saved to #{dot_file}."
end

# change avatar in svg file from local file to online image link
def linkify_avatar_in_svg(svg_file_name, g, avatar_dir)
  avatar_map = build_avatar_map(g)
  svg_file = File.new(svg_file_name)
  lines = svg_file.readlines
  svg_file.close

  lines.each do |line|
    if line.index("<image") == 0
      uid = Frienda::Helper.extract_uid(line)
      avatar_url = avatar_map[uid]
      avatar_local_file = File.join(File.expand_path(avatar_dir), "#{uid}.#{avatar_url[-3, 3]}")
      line.sub!(avatar_local_file, avatar_url)
      LOGGER.debug "Substitue #{avatar_local_file} with #{avatar_url} in SVG file."
    end
  end

  File.open(svg_file.path, 'w') do |file|
    lines.each {|line| file.write(line)}
  end

  system "java -Xmx#{CONFIG['max_memory']} -jar lib/jar/batik-rasterizer.jar report/#{File.basename(svg_file.path)}" if CONFIG['generate_complex_png']
end


###############################################
# Main analysis script
###############################################

report_dir = File.join(File.dirname(__FILE__), '..', 'report')
FileUtils.mkdir(report_dir) unless File.exist?(report_dir)

g = load_graph(File.join(report_dir, 'friends.yml'))

# generate simple image files
if(CONFIG['enable_simple_graph'])
  simple_file_name = 'friends_simple'
  write_dot_file(g, File.join(report_dir, "#{simple_file_name}.dot"))
  generate_image_from_dot(simple_file_name, 'png')
  generate_image_from_dot(simple_file_name, 'svg')
end

# generate image files with avatar
if(CONFIG['enable_avatar_graph'])
  avatar_dir = File.join(report_dir, 'avatars')
  complex_file_name = 'friends_with_avatar'

  download_avatars(g, avatar_dir) if(CONFIG['download_avatar'])

  write_complex_dot_file(g, avatar_dir, File.join(report_dir, "#{complex_file_name}.dot"))

  generate_image_from_dot(complex_file_name, "svg")

  linkify_avatar_in_svg(File.join(report_dir, "#{complex_file_name}.svg"), g, avatar_dir)
end

LOGGER.info "Generated SVG/PNG images are saved to 'report' directory. Please open svg file with Firefox."

