require 'logger'
require 'yaml'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO
LOGGER.datetime_format = "%Y-%m-%d %H:%M:%S"

# read configuration from configure files
CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', '..', 'config.yml'))

module Frienda
  module Helper
    def Helper.extract_uid(line)
      /.*avatars\/(\d+).*/.match(line)[1]
    end
  end
end
