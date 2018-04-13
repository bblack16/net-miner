module TheMovieDB
  class Company
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :name, :description, :headquarters, :country
    attr_ary_of NetMiner::DataTypes::Image, :logos
    attr_of Company, :parent_company, default: nil, allow_nil: true
    attr_of NetMiner::DataTypes::Link, :homepage, allow_nil: true

    self.resources = { paths: 'http://api.themoviedb.org/3/company/{{id}}?api_key={{api_key}}&append_to_response=images', format: :json }

    def self.search(query)
      TheMovieDB.api_key!

      TheMovieDB.process_companies(request(:get, "http://api.themoviedb.org/3/search/company?api_key=#{TheMovieDB.api_key}&query=#{query}").keys_to_sym[:results]).each do |company|
        company.score = matcher.similarity(query, company.name)
      end.sort_by(&:score).reverse
    end

    protected

    def self.load_attributes(id)
      TheMovieDB.validate_id!(id)

      response = request(:get, "#{id}?api_key=#{TheMovieDB.api_key}&append_to_response=images").keys_to_sym

      response.only(:id, :description, :headquarters, :homepage, :name).tap do |attributes|
        attributes[:country]        = response[:origin_country]
        attributes[:logos]          = TheMovieDB.process_images(response[:images][:logos])
        attributes[:parent_company] = TheMovieDB.process_companies(attributes[:parent_company]).first if attributes[:parent_company]
      end
    end

  end
end
