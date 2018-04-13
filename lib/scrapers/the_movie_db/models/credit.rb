module TheMovieDB
  class Credit
    include NetMiner::Model

    attr_str :id, required: true
    attr_str :department, :type, :job, :character
    attr_of Person, :person
    attr_of NetMiner::Model, :media, serialize: false
    attr_str :type, :media_type
    attr_ary_of NetMiner::DataTypes::Image, :images

    self.resources = { paths: 'http://api.themoviedb.org/3/credit/{{id}}?api_key={{api_key}}', format: :json }

    protected

    def self.load_attributes(id)
      TheMovieDB.api_key!
      response = request(:get, "#{id}?api_key=#{TheMovieDB.api_key}").keys_to_sym

      response.only(:id, :department, :job, :id, :person).tap do |attributes|
        attributes[:type] = response[:credit_type]
        attributes[:media_type] = response[:media_type]
        attributes[:character] = response[:media][:character]

        attributes[:media] = case response[:media_type]
        when 'tv'
          TvShow.new(id: response[:media][:id], title: response[:media][:name])
        else
          Movie.new(id: response[:media][:id], title: response[:media][:title])
        end
      end
    end

  end
end
