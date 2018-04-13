require_relative 'season'
require_relative 'episode'

module TheMovieDB
  class TVShow
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :title, allow_nil: true
    attr_date :first_aired, :last_aired
    attr_ary_of [Float, Integer], :runtime
    attr_float :popularity
    attr_bool :in_production
    attr_ary_of Company, :production_companies, :networks
    attr_ary_of String, :genres, :languages, :keywords, :origin_country
    attr_of NetMiner::DataTypes::Link, :homepage, allow_nil: true
    attr_str :overview, :status, :type
    attr_of NetMiner::DataTypes::Rating, :rating
    attr_ary_of Credit, :cast, :crew, :created_by
    attr_ary_of NetMiner::DataTypes::Image, :backdrops, :posters
    attr_ary_of NetMiner::DataTypes::Video, :videos
    attr_str :original_language, :original_title
    attr_ary_of Season, :seasons

    self.resources = { paths: 'http://api.themoviedb.org/3/tv/{{id}}?api_key={{api_key}}&append_to_response=videos,images,keywords,credits', format: :json }

    def self.search(query, year: nil, include_adult: true, language: nil, region: nil)
      TheMovieDB.api_key!

      args = { query: query, year: year, include_adult: include_adult, language: language, region: region }.reject { |k, v| v.nil? }

      response = request(:get, "http://api.themoviedb.org/3/search/tv?api_key=#{TheMovieDB.api_key}&#{args.map { |k, v| "#{k}=#{v}" }.join('&')}").keys_to_sym

      response[:results].map do |show|
        show.only()
      end
    end

    protected

    def self.load_attributes(id)
      TheMovieDB.validate_id!(id)

      response = request(:get, "#{id}?api_key=#{TheMovieDB.api_key}&append_to_response=videos,images,keywords,credits").keys_to_sym

      response.only(
        :homepage, :id, :original_language, :overview, :in_production, :origin_country,
        :popularity, :revenue, :runtime, :status, :tagline, :languages, :type
      ).tap do |attributes|

        attributes[:title]                = response[:name]
        attributes[:original_title]       = response[:original_name]
        attributes[:first_aired]          = response[:first_air_date]
        attributes[:last_aired]           = response[:last_air_date]
        attributes[:runtime]              = response[:episode_run_time]
        attributes[:networks]             = TheMovieDB.process_companies(response[:networks])
        attributes[:production_companies] = TheMovieDB.process_companies(response[:production_companies])
        attributes[:videos]               = TheMovieDB.process_videos(response[:videos][:results])
        attributes[:rating]               = TheMovieDB.process_rating(response)
        attributes[:genres]               = response[:genres].map { |k| k[:name] } # TODO Create TV Show mapper and use it here
        attributes[:keywords]             = response[:keywords][:results].map { |k| k[:name] }

        [:backdrops, :posters].each { |attribute| attributes[attribute] = TheMovieDB.process_images(response[:images][attribute]) }
        [:cast, :crew].each { |type| attributes[type] = TheMovieDB.process_credits(response[:credits][type]) }

        attributes[:seasons] = response[:seasons].map do |season|
          {
            id:            season[:id],
            title:         season[:name],
            season_number: season[:season_number],
            overview:      season[:overview],
            air_date:      season[:air_date],
            posters:       TheMovieDB.process_images(file_path: season[:poster_path]),
            tv_show_id:    id
          }
        end
      end
    end

    protected

    def self.load_attributes(id)

    end

  end
end
