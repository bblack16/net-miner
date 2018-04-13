module NetMiner
  module DataTypes
    class Image < File
      attr_int :width, :height, allow_nil: true
      attr_str :thumbnail, default_proc: :url
      attr_of Rating, :rating, default_proc: proc { Rating.new(value: 0) }

      def aspect_ratio
        return 0 unless width && height
        return 0 if width.zero? && height.zero?
        width / height.to_f
      end

    end
  end
end
