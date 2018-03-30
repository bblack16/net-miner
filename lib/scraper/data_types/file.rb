module NetMiner
  module DataTypes
    class File < Link

      attr_str :extension, allow_nil: true

      def download(path, name: nil)
        name = filename unless name
        response = RestClient.get(url)
        FileUtils.mkpath(path) if path && !Dir.exist?(path)
        open("#{path}/#{name}".pathify, 'wb') do |file|
          file << response
        end
      end

      def filename
        begin
          response = RestClient::Request.execute(method: :head, url: url)
        rescue SocketError, RestClient::Exception => _e
          response = nil
        end
        return response.headers[:content_disposition].scan(/(?<=filename\=\").*(?=\")/i).first if response && response.headers.include?(:content_disposition)
        name = url.gsub('\\', '/').split('/').last.split('?').first
        name = "#{name}.#{extension}" if !name.include?('.') && extension
        name
      end

      protected

      def parse_url
        super
        ext = ::File.extname(url.split('?').first).sub('.', '')
        self.extension = ext if ext && !ext.empty?
      end

    end
  end
end
