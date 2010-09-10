require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/frienda/friend.rb'
require File.dirname(__FILE__) + '/../lib/frienda/frienda_helper.rb'
require 'rubygems'
require 'rgl/adjacency'

describe "Friend model" do

  before :all do
  end
  
  before :each do
    @bush = Frienda::Friend.new
    @bush.uid = 'president'
    @bush.name = 'Bush'
    @obama = Frienda::Friend.new
    @obama.uid = 'president'
    @obama.name = 'Obama'
  end

  it "should be equal if they have same uid" do
    @bush.eql?(@obama).should == true
  end

  it "should have the same hash value if they have the same uid" do
    @bush.hash.should == @obama.hash
  end

  it "should not be added to graph if two friends are the same one" do
    g = RGL::AdjacencyGraph.new
    g.add_vertex(@bush)
    g.vertices.length.should == 1
    g.vertices[0].eql?(@obama).should == true
    g.has_vertex?(@obama).should == true
    g.add_vertex(@obama)
    g.vertices.length.should == 1
  end

  it "should only display last character of name if privacy is enabled" do
    friend = Frienda::Friend.new
    friend.uid = "100"
    friend.name = "奥巴马"
    friend.to_s.should == '奥巴马'
    CONFIG['enable_privacy'] = true
    friend.to_s.should_not == '奥巴马'
    friend.to_s.should == '马马'
  end

end
