module TheMovieDB
  class Movie
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :imdb_id
    attr_str :title, allow_nil: true
    attr_bool :adult, default: false
    attr_int :year, default_proc: proc { |x| x.release.year if x.release }
    attr_date :release
    attr_of Collection, :collection
    attr_int :budget, :revenue
    attr_float :runtime, :popularity
    attr_ary_of Company, :production_companies
    attr_ary_of String, :genres, :languages, :countries, :keywords
    attr_of NetMiner::DataTypes::Link, :homepage, allow_nil: true
    attr_str :overview, :status, :tagline
    attr_of NetMiner::DataTypes::Rating, :rating
    attr_ary_of Credit, :cast, :crew
    attr_ary_of NetMiner::DataTypes::Image, :backdrops, :posters
    attr_ary_of NetMiner::DataTypes::Video, :videos
    attr_str :original_language, :original_title

    self.resources = { paths: 'http://api.themoviedb.org/3/movie/{{id}}?api_key={{api_key}}&append_to_response=videos,images,keywords,credits', format: :json }
    self.search_resource = {
      paths: [
        'http://api.themoviedb.org/3/search/movie?api_key={{api_key}}',
        'http://api.themoviedb.org/3/search/movie?api_key={{api_key}}&year={{year}}'
      ],
      format: :json
    }
    self.search_field = :title

    def self.search(query, year: nil, include_adult: true, language: nil, region: nil)
      TheMovieDB.api_key!
      args = { query: query, year: year, include_adult: include_adult, language: language, region: region }.reject { |k, v| v.nil? }

      response = request(:get, "http://api.themoviedb.org/3/search/movie?api_key=#{TheMovieDB.api_key}&#{args.map { |k, v| "#{k}=#{v}" }.join('&')}").keys_to_sym

      response[:results].map do |result|
        result_year = Time.parse(result[:release_date]).year rescue 0
        score = matcher.similarity(query, result[:title])
        score = (score + matcher.similarity(year, result_year)) / 2.0 if year
        new(
          id:                result[:id],
          title:             result[:title],
          year:              result_year,
          release:           result[:release_date],
          overview:          result[:overview],
          adult:             result[:adult],
          popularity:        result[:popularity],
          original_language: result[:original_language],
          original_title:    result[:original_title],
          score:             score
        )
      end.sort_by { |movie| [movie.score, movie.popularity] }.reverse
    end

    protected

    def self.execute_search(query)
      TheMovieDB.api_key!
      args = query.reject { |k, v| v.nil? }

      request(:get, "http://api.themoviedb.org/3/search/movie?api_key=#{TheMovieDB.api_key}&#{args.map { |k, v| "#{k}=#{v}" }.join('&')}").keys_to_sym
    end

    def self.load_attributes(id)
      TheMovieDB.validate_id!(id)

      response = request(:get, "#{id}?api_key=#{TheMovieDB.api_key}&append_to_response=videos,images,keywords,credits").keys_to_sym

      response.only(
        :adult, :budget, :homepage, :id, :imdb_id, :original_language, :original_title, :overview,
        :popularity, :revenue, :runtime, :status, :tagline, :title
      ).tap do |attributes|

        [:spoken_languages, :production_countries].each do |field|
          attributes[field] = response[field].map { |item| item[:name] }.uniq
        end
        attributes[:genres]               = response[:genres].map { |genre| NetMiner::Mappings.match(:movie_genre, genre[:name]) }.compact.uniq
        attributes[:languages]            = attributes.delete(:spoken_languages)
        attributes[:countries]            = attributes.delete(:production_countries)
        attributes[:release]              = response[:release_date]
        attributes[:keywords]             = response[:keywords][:keywords].map { |k| k[:name] }
        attributes[:rating]               = TheMovieDB.process_rating(response)
        attributes[:production_companies] = TheMovieDB.process_companies(response[:production_companies])
        attributes[:videos]               = TheMovieDB.process_videos(response[:videos][:results])
        attributes[:collection]           = TheMovieDB.process_collection(response[:belongs_to_collection]) if response[:belongs_to_collection]

        [:backdrops, :posters].each { |attribute| attributes[attribute] = TheMovieDB.process_images(response[:images][attribute]) }
        [:cast, :crew].each { |type| attributes[type] = TheMovieDB.process_credits(response[:credits][type]) }

      end
    end

  end
end
