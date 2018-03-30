module NetMiner
  module Model
    FORMATS = [:html, :xml, :json, :yaml, :text].freeze

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, BBLib::Effortless)
      base.send(:attr_of, [Integer, String], :id)
      base.send(:attr_str, :base_url, default: nil, allow_nil: true, singleton: true)
      base.send(:attr_element_of, FORMATS, :default_format, default: FORMATS.first, singleton: true)
      base.send(:attr_bool, :scraped, default: false, serialize: false)
      base.send(:attr_int_between, 0, 100, :score, serialize: false)
      base.send(:attr_of, BBLib::FuzzyMatcher, :matcher, default: BBLib::FuzzyMatcher.new(case_sensitive: false, remove_symbols: true, move_articles: true, convert_roman: true), singleton: true, serialize: false)
      base.send(:bridge_method, :type, :name, :matcher, :request)
    end

    def rescrape
      return self unless id
      self.class.find(id).serialize.each do |key, value|
        self.send("#{key}=", value)
      end
      self
    end

    module ClassMethods
      def [](id)
        raise AbstractError
      end

      def find(id)
        self[id]
      end

      def all
        raise AbstractError
      end

      def first
        all.first
      end

      def last
        all.last
      end

      def sample
        all.sample
      end

      def count
        all.count
      end

      def search(query)
        raise AbstractError
      end

      def name
        self.to_s.split('::').last.method_case.to_sym
      end

      # Should be overriden in child classes and describe what type of items this
      # scraper managers:
      # Examples: :game, :music, :tv, :movie, etc...
      def type
        nil
      end

      def request(method, url, format = default_format, opts = {})
        BBLib::TaskTimer.start(:net_miner_scrape)
        url = "#{base_url}#{url}" if base_url && !(url =~ /^https?\:\/\//i)
        cache = true
        unless result = Cache.retrieve_by_url(url)
          result = RestClient::Request.execute(opts.merge(method: method, url: url)).body
          Cache.cache_url(url, result)
          cache = false
        end
        BBLib.logger.debug("(#{BBLib::TaskTimer.stop(:net_miner_scrape)}s) #{(cache ? 'cache' : self.to_s).upcase} #{url}")
        format_data(result, format)
      end

      def format_data(data, format = :html)
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
end
