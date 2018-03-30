require_relative 'model'
require_relative 'cache'
require_relative 'data_types/link'
require_relative 'data_types/file'
require_relative 'data_types/image'
require_relative 'data_types/rating'
require_relative 'data_types/video'
require_relative 'data_types/credit'
require_relative 'data_types/company'

module NetMiner
  class Scraper
    include BBLib::Effortless
    include BBLib::Prototype

    FORMATS = [:html, :xml, :json, :yaml, :text].freeze

    attr_str :base_url, default: nil, allow_nil: true, singleton: true
    attr_element_of FORMATS, :default_format, default: FORMATS.first, singleton: true

    def self.name
      self.to_s.split('::').last.method_case.to_sym
    end

    # Should be overriden in child classes and describe what type of items this
    # scraper managers:
    # Examples: :game, :music, :tv, :movie, etc...
    def self.type
      nil
    end

    bridge_method :type, :name

    def self.request(method, url, format = default_format, opts = {})
      BBLib::TaskTimer.start(:net_miner_scrape)
      url = "#{base_url}#{url}" if base_url && !(url =~ /^https?\:\/\//i)
      cache = true
      unless result = Cache.retrieve_by_url(url)
        result = RestClient::Request.execute(opts.merge(method: method, url: url)).body
        Cache.cache_url(url, result)
        cache = false
      end
      BBLib.logger.debug("(#{BBLib::TaskTimer.stop(:net_miner_scrape)}s) #{(cache ? 'cache' : name).upcase} #{url}")
      format_data(result, format)
    end

    def self.format_data(data, format = :html)
      case format
      when :html
        Nokogiri::HTML.parse(CGI.unescapeHTML(data))
      when :xml
        Nokogiri::XML.parse(CGI.unescapeHTML(data))
      when :json
        JSON.parse(data)
      when :yaml
        YAML.load(data)
      when :text
        CGI.unescapeHTML(data.to_s)
      else
        raise ArgumentError, "Unknown format type: #{format}"
      end
    end

  end
end
