module NetMiner
  class Content
    include BBLib::Effortless

    attr_of Object, :content, required: true, arg_at: 0
    attr_sym :format, default: :not_set

    def to_s
      case format
      when :json
        JSON.pretty_generate(content)
      when :yaml
        content.to_yaml
      else
        content.to_s
      end
    end

    def extract(expression, opts = {})
      result = case content
      when Hash
        content.hpath(expression)
      when String
        content.scan(expression)
      when Nokogiri::XML::Document, Nokogiri::HTML::Document, Nokogiri::XML::Element, Nokogiri::HTML::Element
        content.send(opts[:type] == :css ? :css : :xpath, expression).map(&:text)
      else
        raise TypeError, "Cannot extract attributes from #{content.class}."
      end
      opts[:singular] ? result.first : result
    end

    def extract_one(expression, opts = {})
      extract(expression, opts.merge(singular: true))
    end

    # Similar to extract but avoids casting values from XML or HTML documents
    def extract_node(expression, opts = {})
      case content
      when Nokogiri::XML::Document, Nokogiri::HTML::Document, Nokogiri::XML::Element, Nokogiri::HTML::Element
        content.send(opts[:type] == :css ? :css : :xpath, expression)
      else
        extract(expression, opts)
      end
    end
  end
end
