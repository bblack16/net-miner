require_relative 'resource'
require_relative 'model'
require_relative 'cache'
require_relative 'data_types/rating'
require_relative 'data_types/link'
require_relative 'data_types/file'
require_relative 'data_types/image'
require_relative 'data_types/video'

module NetMiner
  def self.request(method, url, opts = {})
    format = opts.delete(:format)
    BBLib::TaskTimer.start(:net_miner_scrape)
    cache = true
    BBLib.logger.debug("(0s) About to scrape #{url}")
    unless result = Cache.retrieve_by_url(url)
      result = RestClient::Request.execute(opts.merge(method: method, url: url)).body
      Cache.cache_url(url, result)
      cache = false
    end
    BBLib.logger.debug("(#{BBLib::TaskTimer.stop(:net_miner_scrape)}s) #{(cache ? 'cache' : self.to_s).upcase} #{url}")
    format = detect_format(result.to_s) unless format
    Content.new(format_data(result.to_s, format), format: format)
  end

  def self.format_data(data, format = nil)
    format = detect_format(data) unless format
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

  def self.detect_format(string)
    string = string.strip
    if (string.encap_by?('{') || string.encap_by?(']')) && (JSON.parse(string) rescue false)
      :json
    elsif string =~ /^\<\?xml /
      :xml
    elsif string.encap_by?('<')
      :html
    elsif (YAML.load(string)&.is_a?(Hash) rescue false)
      :yaml
    else
      :text
    end
  end
end
