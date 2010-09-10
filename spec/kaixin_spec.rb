require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/frienda/kaixin_client.rb'
require File.dirname(__FILE__) + '/../lib/frienda/frienda_helper.rb'

describe "Kaixin http client" do

  before :all do
    @client = Frienda::KaixinClient.new
    @login_response = login
  end
  
  before :each do
  end

  it "should redirect after successful login" do
    @login_response.should_not be_nil
    @login_response.class.should == Net::HTTPFound
    @login_response['Location'].should == '/home/'
  end

  it "should get friends list" do
    res = @client.friends
    res.class.should == Net::HTTPOK
  end

  it "should get home" do
    res = @client.home
    res.class.should == Net::HTTPOK
  end
  
  def login
    @client.login(CONFIG['email'], CONFIG['password'])
  end
end
