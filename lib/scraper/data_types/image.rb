module NetMiner
  module DataTypes
    class Image < File
      attr_str :type, allow_nil: true, serialize: false
      attr_int :width, :height, allow_nil: true
      attr_str :thumbnail, default_proc: :url

      before :url=, :reset_attributes
      before :width, :height, :type, :extension, :load_image_properties

      def load_image_properties
        # require 'fastimage' unless defined?(FastImage)
        # self.type = FastImage.type(url) unless @type
        # self.extension = (@type == 'jpeg' ? 'jpg' : @type) unless @extension
        # self.width, self.height = FastImage.size(url) unless @width || @height
      rescue => e
        BBLib.logger.debug("Failed to load image properties with fastimage: #{e}")
        nil
      end

      protected

      def reset_attributes
        self.width     = nil
        self.height    = nil
        self.type      = nil
        self.extension = nil
      end

    end
  end
end
