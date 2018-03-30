require_relative 'item'

module NetMiner
  class Map
    include BBLib::Effortless

    attr_sym :name
    attr_ary_of Item, :items, add_rem: true
    attr_float :default_threshold, default: 50

    def add_attributes(name, hash)
      item(name)&.add_attributes(hash)
    end

    def item(name)
      items.find { |item| item.value == name }
    end

    def match(value, attribute = :value)
      items.find { |item| item.match?(value) }&.attribute(attribute)
    end

    def best_match(value, attribute = :value, threshold: default_threshold)
      result = items.map do |item|
        similarity = item.similarity(value)
        return item.attribute(attribute) if similarity == 100.0
        { value: item.attribute(attribute), similarity: similarity }
      end.sort_by { |val| val[:similarity] }.reverse.first

      return nil if result[:similarity] < threshold
      result[:value]
    end

    def evaluate(value, attribute = :value)
      items.map do |item|
        { value: item.attribute(attribute), similarity: item.similarity(value) }
      end.sort_by { |val| val[:similarity] }.reverse
    end

  end
end

require_relative 'mappings'
