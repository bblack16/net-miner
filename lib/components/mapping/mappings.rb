
# Import all of the default mappings
BBLib.scan_files(File.expand_path('../maps', __FILE__), '*.rb', recursive: true) do |file|
  require_relative file
end

module NetMiner
  module Mappings
    def self.match(type, value, attribute = :value)
      return nil unless mapper = map(type)
      mapper.match(value, attribute)
    end

    def self.best_match(type, value, attribute = :value)
      return nil unless mapper = map(type)
      mapper.best_match(value, attribute)
    end

    def self.map(type)
      Map.instances.find { |map| map.name == type.to_sym }
    end
  end
end
