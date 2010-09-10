require 'rubygems'
require File.dirname(__FILE__) + '/../lib/frienda/frienda_helper.rb'
require File.dirname(__FILE__) + '/../lib/frienda/digger.rb'
require 'yaml'

# build graph
digger = Frienda::Digger.new(CONFIG['email'], CONFIG['password'])
g = digger.friend_graph

# save friend graph to file
report_dir = File.join(File.dirname(__FILE__), '..', 'report')
FileUtils.mkdir(report_dir) unless File.exist?(report_dir)

graph_file = File.join(report_dir, 'friends.yml')
File.open(graph_file, 'w') do |out|
  YAML.dump({:vertices => g.vertices, :edges => g.edges}, out)
end
LOGGER.info "Graph data is dumped to #{graph_file}"
