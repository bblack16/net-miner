module TheMovieDB
  class Person
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :name, arg_at: 0
    attr_str :biography, :imdb_id, :place_of_birth
    attr_bool :adult, default: false
    attr_date :birthday, :deathday, allow_nil: true
    attr_float :popularity
    attr_ary_of String, :aliases
    attr_element_of TheMovieDB::GENDERS.values, :gender, default: :unknown, fallback: :unknown
    attr_of NetMiner::DataTypes::Link, :homepage, allow_nil: true
    attr_ary_of NetMiner::DataTypes::Image, :images
    # TODO Add credits

    self.resources = { paths: 'http://api.themoviedb.org/3/person/{{id}}?api_key={{api_key}}&append_to_response=images', format: :json }

    def self.search(query, include_adult: true)
      TheMovieDB.api_key!
      args = { query: query, include_adult: include_adult }

      response = request(:get, "http://api.themoviedb.org/3/search/person?api_key=#{TheMovieDB.api_key}&#{args.map { |k, v| "#{k}=#{v}" }.join('&')}").keys_to_sym

      response[:results].map do |person|
        new(
          id:    person[:id],
          name:  person[:name],
          adult: person[:adult],
          score: matcher.similarity(query, person[:name])
        )
      end.sort_by(&:score).reverse
    end

    def age
      return nil unless birthday
      age_secs = (deathday ? Time.parse(deathday.to_s) : Time.now) - Time.parse(birthday.to_s)
      (age_secs / 60 / 60 / 24 / 365).floor
    end

    protected

    def self.load_attributes(id)
      TheMovieDB.validate_id!(id)
      response = request(:get, "#{id}?api_key=#{TheMovieDB.api_key}&append_to_response=images").keys_to_sym

      response.only(
        :id, :imdb_id, :biography, :name, :place_of_birth, :birthday,
        :deathday, :popularity, :adult, :homepage
      ).tap do |attributes|
        attributes[:images] = TheMovieDB.process_images(response[:images][:profiles])
        attributes[:gender] = TheMovieDB::GENDERS[response[:gender]]
        attributes[:aliases] = response[:also_known_as]
      end
    end

  end
end
