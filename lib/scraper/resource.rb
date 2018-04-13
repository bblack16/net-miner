require_relative 'content'

module NetMiner
  class Resource
    include BBLib::Effortless

    attr_ary_of String, :paths, arg_at: 0
    attr_str :base_url, allow_nil: true
    attr_sym :name, default: :main, arg_at: 1
    attr_element_of CONTENT_FORMATS, :format, default: :html, arg_at: 2
    attr_element_of REQUEST_TYPE, :method, default: :get, arg_at: 3

    def retrieve(opts = {})
      url = render_url(opts)
      return nil unless url
      Content.new(request(method, url))
    end

    def render_url(opts = {})
      BBLib.pattern_render(best_url_for(opts), opts).tap do |url|
        return "#{base_url}#{url}" if base_url && !(url =~ /^https?\:\/\//i)
      end
    end

    def best_url_for(query = {})
      best_path = nil
      best_score = -1
      paths.each do |path|
        placeholders = placeholders_in(path)
        missing = placeholders.map(&:to_s) - query.keys.map(&:to_s)
        next unless missing.empty?
        score = placeholders.size
        next if best_score >= score
        best_path = path
        best_score = score
      end
      best_path
    end

    def placeholders_in(path)
      path.to_s.scan(/\{{2}(.*?)\}{2}/).flatten
    end

    protected

    def request(method, url, opts = {})
      BBLib::TaskTimer.start(:net_miner_scrape)
      url = "#{base_url}#{url}" if base_url && !(url =~ /^https?\:\/\//i)
      cache = true
      BBLib.logger.debug("(0s) About to scrape #{url}")
      unless result = Cache.retrieve_by_url(url)
        result = RestClient::Request.execute(opts.merge(method: method, url: url)).body
        Cache.cache_url(url, result)
        cache = false
      end
      BBLib.logger.debug("(#{BBLib::TaskTimer.stop(:net_miner_scrape)}s) #{(cache ? 'cache' : self.to_s).upcase} #{url}")
      format_data(result)
    end

    def format_data(data)
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
