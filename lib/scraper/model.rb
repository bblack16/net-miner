module NetMiner
  module Model

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, BBLib::Effortless)
      base.send(:attr_of, [Integer, String, Array], :id)
      base.send(:attr_ary_of, Resource, :resources, singleton: true, private: true)
      base.send(:attr_of, Resource, :search_resource, singleton: true, allow_nil: true, private: true)
      base.send(:attr_sym, :search_field, singleton: true, allow_nil: true, private: true)
      base.send(:attr_bool, :scraped, default: false, serialize: false)
      base.send(:attr_float_between, 0, 100, :score, default: 100, serialize: false)
      base.send(:attr_of, BBLib::FuzzyMatcher, :matcher, default: BBLib::FuzzyMatcher.new(case_sensitive: false, remove_symbols: true, move_articles: true, convert_roman: true), singleton: true, serialize: false)
      base.send(:attr_bool, :check_memory, default: true, singleton: true)
      base.send(:bridge_method, :type, :name, :matcher, :request, :auto_load_attributes)
      base.singleton_class.send(:before, :[], :_check_memory, try_first: true, send_args: true)
      base.singleton_class.send(:before, :new, :_check_memory_and_update, try_first: true, send_args: true)
    end

    def update(attributes)
      attributes.each do |variable, value|
        method = "#{variable}="
        next unless respond_to?(method)
        send(method, value)
      end
      self
    end

    def refresh
      update(auto_load_attributes(id).merge(scraped: true))
    end

    def scrape
      scraped? ? self : refresh
    end

    module ClassMethods
      def [](id)
        new(auto_load_attributes(id))
      end

      alias find []

      def all
        raise AbstractError, "#{self} does not support the :all method or any aggregations that use it."
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

      def search(query, args = {})
        raise AbstractError, "#{self} does not support searching (the search method is not implemented or no search resource is defined.)" unless search_resource
        full_query = args.merge(query: query)
        process_query(full_query) if respond_to?(:process_query)
        content = execute_search(full_query)
        results = process_search_results(content)
        sort_search_results(query, results, args)
      end

      def best_match(*args)
        named = BBLib.named_args(*args)
        match = search(*args)&.first
        return match if match.nil? || !named.include?(:threshold)
        named[:threshold] <= match.score ? match : nil
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

      protected

      # Returns a hash of context to be merged into each call to the page render_url method.
      # The primary use of this is to inject an API key into each request (for example).
      def default_url_context
        {}
      end

      # Hook for making modifications to the query hash before sending it to a
      # resource for scraping. Default does nothing to it.
      def process_query(query)
        # Nothing in default
      end

      # Returns all attr setters that have the :net_miner_search_path option set
      def _search_attributes
        _attrs.hmap do |name, settings|
          opts = settings[:options]
          next unless opts[:net_miner_search_path]
          [name, opts[:net_miner_search_path]]
        end
      end

      # This method is called during search and should return a Content object
      # containing the search results for the query (Hash)
      def execute_search(query)
        search_resource.retrieve(query)
      end

      # Search results are passed to this method by the search method to extract
      # various attributes from. By default this looks for attr methods that
      # have the :net_miner_search_path option set and extracts them from
      # the content and then creates objects from that.
      def process_search_results(content)
        extractions = _search_attributes.hmap do |name, expression|
          [name, content.extract(expression)]
        end

        [].tap do |results|
          extractions.values.map(&:size).max.times do |index|
            result = {}
            extractions.each do |key, value|
              result[key] = value[index]
            end
            results << new(result)
          end
        end
      end

      # Contruct URLs for each configured resource and then request
      # them via REST calls.
      def scrape_resources(opts = {})
        BBLib::HashStruct.new.tap do |hash|
          resources.each do |resource|
            hash[resource.name] = resource.retrieve(opts)
          end
        end
      end

      def auto_load_attributes(id, args = {})
        pages = scrape_resources(args.merge(id: id).merge(default_url_context))
        {}.tap do |results|
          pages.each do |resource_name, content|
            _attrs.each do |method, settings|
              opts = settings[:options]
              next unless opts[:net_miner_path]
              next unless opts[:net_miner_resource] == resource_name || opts[:net_miner_resource].nil? && resource_name == :main
              extract_ops = opts[:net_miner_opts] || {}
              extract_ops[:singular] = true unless extract_ops.include?(:singular) || settings[:type].to_s =~ /array/i
              results[method] = content.extract(opts[:net_miner_path], extract_ops)
            end
          end
          load_attributes(results, pages)
        end
      end

      def load_attributes(attributes, pages = {})
        # raise AbstractError, "The load_attributes method must be defined in subclasses. Currently it is not for #{self}."
      end

      def sort_search_results(query, results, args = {})
        return results unless search_field
        results.each do |result|
          next unless result.respond_to?(search_field)
          result.score = matcher.similarity(query.to_s, result.send(search_field).to_s)
        end
        results.sort_by(&:score).reverse
      end

      def _check_memory(id)
        return nil unless check_memory?
        self.instances.find do |descendant|
          next unless descendant.respond_to?(:id)
          id.to_s == descendant.id.to_s
        end
      end

      def _check_memory_and_update(*args, &block)
        return nil unless check_memory?
        named = BBLib.named_args(*args)
        return nil unless named[:id]
        object = _check_memory(named[:id])
        return nil unless object
        object.update(named.except(:id))
      end
    end
  end
end
