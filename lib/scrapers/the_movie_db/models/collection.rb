module TheMovieDB
  class Collection
    include NetMiner::Model

    attr_int :id, required: true
    attr_str :title, :overview
    attr_ary_of NetMiner::Model, :movies
    attr_ary_of NetMiner::DataTypes::Image, :posters, :backdrops

    self.resources = { paths: 'http://api.themoviedb.org/3/collection/{{id}}?api_key={{api_key}}&append_to_response=images', format: :json }

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

      response.only(:id, :overview).tap do |attributes|
        attributes[:title]     = response[:name]
        attributes[:posters]   = TheMovieDB.process_images(response[:images][:posters])
        attributes[:backdrops] = TheMovieDB.process_images(response[:images][:backdrops])
        attributes[:movies]    = response[:parts].each do |movie|
          {
            id:              movie[:id],
            title:           movie[:title],
            adult:           movie[:adult],
            overview:        movie[:overview],
            origintal_title: movie[:original_title],
            release_date:    movie[:release_date],
            popularity:      movie[:popularity],
            rating:          TheMovieDB.process_rating(movie)
          }
        end
      end
    end

  end
end
