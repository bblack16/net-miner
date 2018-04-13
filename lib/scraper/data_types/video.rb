module NetMiner
  module DataTypes
    class Video < Link

      attr_str :title, :language, default: nil, allow_nil: true
      attr_int :width, :height, allow_nil: true

      def id
        case site.to_s.downcase
        when :youtube
          url.scan(/[\?\&]v\=([\w\d]{11})/).flatten.first
        end
      end

      def embedable_url
        case site.to_s.downcase
        when 'youtube'
          "https://youtube.com/embed/#{id}"
        end
      end

      def aspect_ratio
        return 0 unless width && height
        width / height.to_f
      end

    end
  end
end
