require_relative 'net_miner/version'

require 'rest-client'
require 'json'
require 'yaml'
require 'nokogiri'
require 'digest'
require 'cgi'

require_relative 'util/constants'
require_relative 'scraper/scraper'
require_relative 'components/mapping/map'
require_relative 'components/api_key_scraper'

# Blanket require all scrapers
BBLib.scan_files(File.expand_path('../scrapers', __FILE__), '*.rb') do |file|
  require_relative file
end
