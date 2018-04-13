module TheMovieDB
  class Network
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :name, :headquarters, :country
    attr_ary_of NetMiner::DataTypes::Image, :logos
    attr_of NetMiner::DataTypes::Link, :homepage, allow_nil: true

    self.resources = { paths: 'http://api.themoviedb.org/3/network/{{id}}?api_key={{api_key}}&append_to_response=images', format: :json }

    protected

    def self.load_attributes(id)
      TheMovieDB.validate_id!(id)

      response = request(:get, "#{id}?api_key=#{TheMovieDB.api_key}&append_to_response=images").keys_to_sym

      response.only(:id, :headquarters, :homepage, :name).tao do |attributes|
        attributes[:country] = response[:origin_country]
        attributes[:logos]   = TheMovieDB.process_images(response[:images][:logos])
      end
    end

  end
end
