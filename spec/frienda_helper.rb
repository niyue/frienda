require File.dirname(__FILE__) + '/../lib/frienda/frienda_helper.rb'

describe "Frienda helper" do
  
  it "should extract uid from string in svg file" do
    line = "<image xlink:href=\"/Users/yue/dev/workspace/frienda/report/avatars/7817027.jpg\" preserveAspectRatio=\"xMinYMin meet\"/>"
    uid = Frienda::Helper.extract_uid(line)
    uid.should == '7817027'
  end
  
end
