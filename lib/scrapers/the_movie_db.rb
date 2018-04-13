require 'net_miner' unless defined?(NetMiner::VERSION)

module TheMovieDB
  extend NetMiner::APIKeyScraper
  IMAGE_BASE_ORIGINAL = 'https://image.tmdb.org/t/p/original'
  IMAGE_BASE_THUMB = 'https://image.tmdb.org/t/p/w200_and_h300_bestv2'
  GENDERS = { 0 => :unknown, 1 => :female, 2 => :male }.freeze

  def self.validate_id!(id)
    api_key!
    raise ArgumentError, "Invalid ID for TheMovieDB. Should be an integer or integer string not #{id}." unless id.is_a?(Integer) || id =~ /^\d+$/
  end

  def self.api_key!
    raise ArgumentError, "No API key set for TheMovieDB. Please call TheMovieDB.api_key='your_key' to set it (must be valid)" unless TheMovieDB.api_key
  end

  def self.process_credits(credits)
    [credits].flatten(1).map do |credit|
      Credit.new(
        id: credit[:credit_id],
        character: credit[:character],
        job: credit[:job],
        department: credit[:department],
        person: {
          id: credit[:id],
          gender: GENDERS[credit[:gender]],
          name: credit[:name]
          # TODO Add profile
        }
      )
    end
  end

  def self.process_images(images)
    [images].flatten(1).map do |image|
      {
        url:       "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{image[:file_path] || image[:poster_path]}",
        thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{image[:file_path] || image[:poster_path]}",
        width:     image[:width],
        height:    image[:height],
        language:  image[:iso_639_1],
        rating: {
          value: image[:vote_average] || 0,
          scale: 10,
          votes: image[:vote_count] || 0
        },
        metadata: image.except(:file_path, :width, :height,:iso_639_1, :vote_average, :vote_count, :poster_path)
      }
    end
  end

  def self.process_videos(videos)
    [videos].flatten(1).map do |video|
      url = case video[:site]
      when /^youtube$/i
        "https://www.youtube.com/watch?v=#{video[:key]}"
      else
        video[:key] # TODO Verify this is correct. What non-youtube sites can there be?
      end
      {
        url:    url,
        title:  video[:name],
        width:  video[:size],
        height: (video[:size] * (16 / 9.0)).to_i # This is a best guess that assumes the aspect is 16:9
      }
    end
  end

  def self.process_rating(obj)
    NetMiner::DataTypes::Rating.new(value: obj[:vote_average], scale: 10, votes: obj[:vote_count])
  end

  def self.process_companies(companies)
    [companies].flatten(1).map do |company|
      TheMovieDB::Company.new(
        id:      company[:id],
        name:    company[:name],
        country: company[:origin_country],
        logos:   {
          url: "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{company[:logo_path]}",
          thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{company[:logo_path]}"
        }
      )
    end
  end

  def self.process_networks(networks)

  end

  def self.process_collection(collection)
    {
      id:     collection[:id],
      title:  collection[:name],
      posters: {
        url:       "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{collection[:poster_path]}",
        thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{collection[:poster_path]}"
      },
      backdrops: {
        url:       "#{TheMovieDB::IMAGE_BASE_ORIGINAL}#{collection[:backdrop_path]}",
        thumbnail: "#{TheMovieDB::IMAGE_BASE_THUMB}#{collection[:backdrop_path]}"
      }
    }.tap do |coll|
      coll.delete(:posters) unless collection[:poster_path]
      coll.delete(:backdrops) unless collection[:backdrop_path]
    end
  end
end

require_relative 'the_movie_db/models/collection'
require_relative 'the_movie_db/models/person'
require_relative 'the_movie_db/models/credit'
require_relative 'the_movie_db/models/review'
require_relative 'the_movie_db/models/company'
require_relative 'the_movie_db/models/network'
require_relative 'the_movie_db/models/movie'
require_relative 'the_movie_db/models/tv_show'
