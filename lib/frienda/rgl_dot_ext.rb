require 'rubygems'
require 'rgl/dot'
require 'rgl/rdot'

module RGL
  module Graph
    def to_complex_dot_graph(params = {})
      params['name'] ||= self.class.name.gsub(/:/,'_')
      fontsize   = params['fontsize'] ? params['fontsize'] : '8'
      graph      = (directed? ? DOT::Digraph : DOT::Subgraph).new(params)
      edge_class = directed? ? DOT::DirectedEdge : DOT::Edge
      each_vertex do |v|
        name = v.to_s
        avatar = "#{params['shapefile']}/#{v.uid}.#{v.avatar[-3, 3]}" if params['shapefile']
        node = {
          'name' => v.uid.to_s,
          'fontsize' => fontsize,
          'label' => "<<table border=\"0\"><tr><td><img src=\"#{avatar}\"/></td></tr><tr><td>#{name}</td></tr></table>>"
        } 

        graph << DOT::Node.new(node)
      end
      each_edge do |u,v|
        graph << edge_class.new('from'     => u.uid.to_s,
                                'to'       => v.uid.to_s,
                                'fontsize' => fontsize)
      end
      graph
    end
  end
end
