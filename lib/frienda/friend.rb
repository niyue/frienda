require 'yaml'
require File.join(File.dirname(__FILE__), 'frienda_helper')

module Frienda
  class Friend
    attr_accessor :uid
    attr_accessor :name
    attr_accessor :avatar
    attr_accessor :gender

    def eql?(other)
      self == (other)
    end

    def ==(other)
      other.equal?(self) || (other.instance_of?(self.class) && other.uid == uid)
    end

    def hash
      uid.hash
    end

    def to_s
        last = name.scan(/./u)[-1, 1]
        CONFIG['enable_privacy'] ? "#{last}#{last}" : name
    end
  end
end
