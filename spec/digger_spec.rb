require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/frienda/digger.rb'
require File.dirname(__FILE__) + '/../lib/frienda/frienda_helper.rb'
require 'rubygems'
require 'rgl/dot'

describe "Frienda digger" do
  
  it "should get a friend graph" do
    digger = Frienda::Digger.new(CONFIG['email'], CONFIG['password'])
    g = digger.friend_graph
    g.should_not be_nil
    g.vertices.length.should == 21
  end
  
end
