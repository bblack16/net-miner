module NetMiner
  module DataTypes
    class Link
      include BBLib::Effortless

      attr_str :url, required: true, arg_at: 0
      attr_str :language, default: nil, allow_nil: true
      attr_hash :metadata

      def site
        url.scan(/https?\:\/\/w{3}?\.?(.*?)\.\w{2,3}[$\/\:]/i).flatten.first
      end

      def root
        url.scan(/(https?\:\/\/w{3}?\.?.*?\.\w{2,3})[$\/\:]/i).flatten.first
      end

      def tld
        root.split('.').last if root.include?('.')
      end

      def scheme
        url =~ /^https\:\/\//i ? :https : :http
      end

      def params
        url.split('?').last.split('&').hmap { |val| val.split('=', 2) }.keys_to_sym
      end

    end
  end
end
