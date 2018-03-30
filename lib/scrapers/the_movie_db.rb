require 'net_miner' unless defined?(NetMiner::VERSION)

module TheMovieDB
  extend NetMiner::APIKeyScraper
  IMAGE_BASE_ORIGINAL = 'https://image.tmdb.org/t/p/original'
  IMAGE_BASE_THUMB = 'https://image.tmdb.org/t/p/w200_and_h300_bestv2'
end

require_relative 'the_movie_db/models/collection'
require_relative 'the_movie_db/models/movie'
