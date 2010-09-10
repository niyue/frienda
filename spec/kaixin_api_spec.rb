require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/frienda/kaixin_api.rb'
require File.dirname(__FILE__) + '/../lib/frienda/frienda_helper.rb'

describe "Kaixin API" do

  before :all do
  end
  
  before :each do
    @kaixin = Frienda::KaixinApi.new(CONFIG['email'], CONFIG['password'])
  end

  it "should get friends list by login user's uid if no uid if given" do
    friends = @kaixin.friends
    friends.length.should == 1
  end

  it "should get personal information from home page" do
    me = @kaixin.home
    me.uid.should == '14714748'
  end

end
