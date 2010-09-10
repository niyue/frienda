require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/frienda/scraper.rb'

describe "Kaixin scraper" do

  before :all do
    @friends_page = open(File.join(File.dirname(__FILE__), 'data', 'friends.html'))
    @home_page = open(File.join(File.dirname(__FILE__), 'data', 'me.html'))
  end
  
  before :each do
  end

  it "should be able to scrape friends list from friends page" do
    scraped_friends = Frienda::Scraper.friends(@friends_page)
    friends = scraped_friends[:friends]
    friends.length.should == 3
    friend = friends[0]
    friend.name.should_not be_nil
    friend.uid.should_not be_nil
    friend.avatar.should_not be_nil
    friend.avatar.include?('jpg').should == true
    scraped_friends[:next_page].should == false
  end

  it "should be able to scrape self information from home page" do
    me = Frienda::Scraper.home(@home_page)
    me.uid.should_not be_nil
    me.name.should_not be_nil
    me.avatar.should_not be_nil
    me.uid.should == '14714748'
    me.avatar.include?('gif').should == true
  end
end
