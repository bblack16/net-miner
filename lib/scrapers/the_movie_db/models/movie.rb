module TheMovieDB
  class Movie
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :imdb_id
    attr_str :title, allow_nil: true
    attr_bool :adult, default: false
    attr_int :year, default_proc: proc { |x| x.release.year if x.release }
    attr_time :release
    attr_ary_of Collection, :collections
    attr_int :budget, :revenue
    attr_float :runtime, :popularity
    attr_ary_of NetMiner::DataTypes::Company, :production_companies
    attr_ary_of String, :genres, :languages, :countries, :keywords
    attr_of NetMiner::DataTypes::Link, :homepage, allow_nil: true
    attr_str :overview, :status, :tagline
    attr_of NetMiner::DataTypes::Rating, :rating
    attr_ary_of NetMiner::DataTypes::Credit, :cast, :crew
    attr_ary_of NetMiner::DataTypes::Image, :backdrops, :posters
    attr_ary_of NetMiner::DataTypes::Video, :videos
    attr_str :original_language, :original_title

    self.base_url = 'http://api.themoviedb.org/3/movie/'
    self.default_format = :json


    def self.[](id)
      raise ArgumentError, "No API key set for TheMovieDB. Please call TheMovieDB.api_key='your_key' to set it (must be valid)" unless TheMovieDB.api_key
      raise ArgumentError, "Invalid ID for TheMovieDB. Should be an integer or integer string not #{id}." unless id.is_a?(Integer) || id =~ /^\d+$/

      response = request(:get, "http://api.themoviedb.org/3/movie/#{id}?api_key=#{TheMovieDB.api_key}&append_to_response=videos,images,keywords,credits").keys_to_sym

      args = response.only(
        :adult, :budget, :homepage, :id, :imdb_id, :original_language, :original_title, :overview,
        :popularity, :revenue, :runtime, :status, :tagline, :title
      )

      [:genres, :spoken_languages, :production_countries].each do |field|
        args[field] = response[field].map { |item| item[:name] }.uniq
      end

      args[:languages] = args.delete(:spoken_languages)
      args[:countries] = args.delete(:production_countries)
      args[:release] = response[:release_date]
      args[:keywords] = response[:keywords][:keywords].map { |k| k[:name] }
      args[:rating] = { value: response[:vote_average], scale: 10, votes: response[:vote_count] }

      args[:production_companies] = response[:production_companies].map do |company|
        {
          name: company[:name],
          country: company[:origin_country],
          logo: {
            url: "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{company[:logo_path]}",
            thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{company[:logo_path]}"
          }
        }.tap do |image|
          image.delete(:logo) unless company[:logo_path]
        end
      end

      args[:videos] = response[:videos][:results].map do |video|
        {
          url: "https://www.youtube.com/watch?v=#{video[:key]}",
          title: video[:name],
          width: video[:size],
          height: (video[:size] / (16 / 9.0)).to_i # This is a best guess that assumes the aspect is 16:9
        }
      end

      [:backdrops, :posters].each do |attribute|
        args[attribute] = response[:images][attribute].map do |image|
          {
            url: "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{image[:file_path]}",
            thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{image[:file_path]}",
            width: image[:width],
            height: image[:height],
            language: image[:iso_639_1]
          }
        end
      end

      [:cast, :crew].each do |type|
        args[type] = response[:credits][type].map do |person|
          gender = case person[:gender]
          when 1
            :female
          when 2
            :male
          else
            :unknown
          end
          credit = {
            name: person[:name],
            role: type == :cast ? person[:character] : person[:job],
            gender: gender,
            profile: {
              url: "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{person[:profile_path]}",
              thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{person[:profile_path]}"
            }
          }
          credit.delete(:profile) unless person[:profile_path]
          credit
        end
      end

      if response[:belongs_to_collection]
        args[:collections] = {
          id: response[:belongs_to_collection][:id],
          title: response[:belongs_to_collection][:name],
          poster: {
            url: "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{response[:belongs_to_collection][:poster_path]}",
            thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{response[:belongs_to_collection][:poster_path]}"
          },
          backdrop: {
            url: "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{response[:belongs_to_collection][:backdrop_path]}",
            thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{response[:belongs_to_collection][:backdrop_path]}"
          }
        }
      end

      Movie.new(args.merge(scraped: true, score: 100))
    end

    def self.all
      raise RuntimeError, "TheMovieDB Movies cannot be retrieved using all. Please use search and search by title."
    end

    def self.search(query, year: nil, include_adult: true, language: nil, region: nil)
      raise ArgumentError, "No API key set for TheMovieDB. Please call TheMovieDB.api_key='your_key' to set it (must be valid)" unless TheMovieDB.api_key
      args = { query: query, year: year, include_adult: include_adult, language: language, region: region }.reject { |k, v| v.nil? }

      response = request(:get, "http://api.themoviedb.org/3/search/movie?api_key=#{TheMovieDB.api_key}&#{args.map { |k, v| "#{k}=#{v}" }.join('&')}").keys_to_sym

      max_popularity = response[:results].map { |result| result[:popularity] }.max

      response[:results].map do |result|
        result_year = Time.parse(result[:release_date]).year rescue 0
        score = matcher.similarity(query, result[:title])
        score = (score + matcher.similarity(year, result_year)) / 2.0 if year
        Movie.new(
          id: result[:id],
          title: result[:title],
          year: result_year,
          release: result[:release_date],
          overview: result[:overview],
          adult: result[:adult],
          popularity: result[:popularity],
          original_language: result[:original_language],
          original_title: result[:original_title],
          score: score
        )
      end.sort_by { |movie| [movie.score, movie.popularity] }.reverse
    end

  end
end
