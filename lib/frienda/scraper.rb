require 'rubygems'
require 'hpricot'
require File.dirname(__FILE__) + '/friend.rb'
require File.dirname(__FILE__) + '/frienda_helper.rb'

module Frienda 
  class Scraper
    def Scraper.friends(html)
      friends_page = Hpricot(html)
      friends = []
      friends_page.at('div.gw').search('div.l50_s').each do |friend_div|
         friend = Frienda::Friend.new 
         link = friend_div.at('a')
         friend.name = link['title']
         friend.uid = link['href'].split('=')[1]
         friend.avatar = friend_div.at('img')['src']
         friends << friend
      end
      next_page = html.include?('下一页')
      return {:friends => friends, :next_page => next_page}
    end

    def Scraper.home(html)
      home_page = Hpricot(html)
      me = Frienda::Friend.new 
      me.name = home_page.at('b.f14').inner_text
      info_div = home_page.at('div.l120_s')
      me.avatar = info_div.at('img')['src']
      me.uid = info_div['title'].split(':')[1]
      return me
    end
  end
end
