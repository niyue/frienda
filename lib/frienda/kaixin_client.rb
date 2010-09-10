require File.dirname(__FILE__) + '/frienda_helper.rb'
require 'net/http'
module Frienda 
  class KaixinClient
    REQUEST_INTERVAL = 1
    KAIXIN = URI.parse('http://www.kaixin001.com')
    LOGIN_URL = '/login/login.php'
    HOME_URL = '/home/'
    attr_accessor :uid
    def initialize
      @session = Net::HTTP.start(KAIXIN.host)
    end

    def login(email, password)
      LOGGER.info "Login into kaixin001.com with email #{email}."
      req = Net::HTTP::Post.new(LOGIN_URL)
      req.set_form_data({'email'=> email, 'password'=> password})
      @login_response = @session.request(req)
      @uid = uid_in_cookie
      return @login_response
    end

    def friends(uid = @uid, page = 0)
      sleep REQUEST_INTERVAL
      friends_url = "/friend/?uid=#{uid}&start=#{page*40}"
      LOGGER.info "Request friends page from #{friends_url}."
      req = Net::HTTP::Get.new(friends_url, header)
      response = @session.request(req)
    end

    def home(uid = @uid)
      req = Net::HTTP::Get.new(HOME_URL, header)
      response = @session.request(req)
    end

    private
    def uid_in_cookie
      @uid = cookie.split(';')[2].split('=')[2]
    end

    def cookie
      @login_response['set-cookie']
    end

    def header
      {'Cookie' => cookie}
    end
  end
end
