module NetMiner
  class Cache
    include BBLib::Effortless
    include BBLib::Prototype

    attr_dir :path, default: nil, allow_nil: true, mkdir: true
    attr_hash :cached_objects
    attr_int :ttl, default: 3600 * 24 * 7

    after :path=, :load_cache
    after :cache, :save

    def cache(key, data, expiration = nil, value: nil)
      return false unless path
      cached_objects[key] = CachedObject.new(key: key, data: data, value: value || key, expiration: expiration || Time.now + ttl)
    end

    def cache_url(url, data, expiration = nil)
      cache(Digest::MD5.hexdigest(url), data, expiration, value: url)
    end

    def retrieve(key)
      return nil unless path && obj = cached_objects[key]
      return obj.data unless obj.expired?
      delete(key) # Delete cached item if it is expired
      nil
    rescue Errno::ENOENT => _e
      cached_objects.delete(key)
      nil
    end

    def retrieve_by_url(url)
      retrieve(Digest::MD5.hexdigest(url))
    end

    def delete(key)
      cached_objects[key].delete
      cached_objects.delete(key)
    end

    def clean
      cached_objects.each do |key, obj|
        delete(key) if obj.expired?
      end
      save
    end

    protected

    def simple_init(*args)
      clean
    end

    def save
      return unless path
      cached_objects.hmap { |key, obj| [key, obj.serialize] }.to_yaml.to_file("#{path}/cache.yml", mode: 'w')
    end

    def load_cache
      return unless @path
      file = "#{path}/cache.yml"
      return unless File.exist?(file)
      self.cached_objects = YAML.load_file(file).hmap do |key, obj|
        [key, CachedObject.new(obj)]
      end
      clean
    end

  end

  class CachedObject
    include BBLib::Effortless

    init_type :loose

    attr_str :value
    attr_str :key, required: true
    attr_of Time, :expiration, required: true

    def expired?
      Time.now >= expiration
    end

    def data
      File.read("#{Cache.path}/#{key}.cache")
    end

    def delete
      File.delete("#{Cache.path}/#{key}.cache") if File.exist?("#{Cache.path}/#{key}.cache")
    end

    protected

    def simple_init(*args)
      named = BBLib.named_args(*args)
      if named.include?(:data)
        path = "#{Cache.path}/#{key}.cache"
        named[:data].to_s.to_file(path, mode: 'w')
      end
    end
  end
end
