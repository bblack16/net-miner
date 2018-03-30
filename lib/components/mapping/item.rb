module NetMiner
  class Map
    class Item
      include BBLib::Effortless

      attr_str :value, arg_at: 0
      attr_ary_of [String, Regexp], :aliases
      attr_of Proc, :formatter, default: proc { |x| x.to_s.downcase.drop_symbols }, arg_at: :block
      attr_hash :attributes
      attr_of BBLib::FuzzyMatcher, :matcher, default: BBLib::FuzzyMatcher.new(case_sensitive: false, remove_symbols: true, move_articles: true, convert_roman: true), singleton: true, serialize: false

      bridge_method :matcher

      def match?(value)
        return true if formatter.call(self.value) == formatter.call(value)
        return true if aliases.any? { |als| compare(value, als) }
      end

      def similarity(value)
        a = formatter.call(self.value)
        b = formatter.call(value)
        vsim = matcher.similarity(a, b)
        return vsim if vsim == 100.0
        (
          aliases.map do |als|
            case als
            when Regexp
              b =~ als ? 99.0 : 0
            else
              matcher.similarity(b, formatter.call(als))
            end
          end + [vsim]
        ).max
      end

      def attribute(key)
        return value if key == :value
        attributes[key]
      end

      def add_attributes(hash)
        self.attributes.merge!(hash)
      end

      def compare(value, comparator)
        case comparator
        when Regexp
          formatter.call(value) =~ comparator
        else
          formatter.call(value) == formatter.call(comparator)
        end
      end

    end
  end
end
