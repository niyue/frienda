require File.dirname(__FILE__) + '/frienda_helper.rb'
require File.join(File.dirname(__FILE__), 'kaixin_client')
require File.join(File.dirname(__FILE__), 'scraper')

module Frienda
  class KaixinApi
    attr_accessor :uid
    def initialize(email, password)
      @client = Frienda::KaixinClient.new
      @client.login(email, password)
      @uid = @client.uid
    end

    def friends(uid = @uid)
      friend_list = []
      page = 0
      friends_page = @client.friends(uid, page)
      scraped_friends = Frienda::Scraper.friends(friends_page.body)
      friend_list += scraped_friends[:friends]
      while(scraped_friends[:next_page])
        page += 1
        friends_page = @client.friends(uid, page)
        scraped_friends = Frienda::Scraper.friends(friends_page.body)
        friend_list += scraped_friends[:friends]
      end
      friend_list
    end

    def home(uid = @uid)
      home_page = @client.home(uid).body
      Frienda::Scraper.home(home_page)
    end
  end
end
