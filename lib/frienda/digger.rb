require File.dirname(__FILE__) + '/frienda_helper.rb'
require File.dirname(__FILE__) + '/kaixin_api.rb'
require 'rubygems'
require 'rgl/adjacency'

module Frienda 
  class Digger
    def initialize(email, password)
      @kaixin = Frienda::KaixinApi.new(email, password)
    end

    def friend_graph
      g = RGL::AdjacencyGraph.new
      me = @kaixin.home
      know_person(g, me)
      friends = @kaixin.friends(me.uid)
      for friend in friends
        know_person(g, friend)
        make_friend(g, me, friend)
        foafs = @kaixin.friends(friend.uid)
        for foaf in foafs
          if(not (foaf == me))
            know_person(g, foaf)
            make_friend(g, friend, foaf)
          end
        end
      end
      return g
    end

    private
    def know_person(g, p)
      g.add_vertex(p)
    end

    def make_friend(g, p1, p2)
      LOGGER.debug "#{p1.name} makes friend with #{p2.name}"
      g.add_edge(p1, p2)
    end
  end
end
