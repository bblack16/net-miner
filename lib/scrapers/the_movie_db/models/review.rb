# module TheMovieDB
#   class Review
#     include NetMiner::Model
#     attr_int :id, required: true
#     attr_date :start_date
#     attr_str :name, :overview
#     attr_int :number
#     attr_ary_of NetMiner::DataTypes::Image, :posters, :backdrops
#
#     self.base_url = 'http://api.themoviedb.org/3/tv/'
#     self.default_format = :json
#
#     def self.[](id)
#       TheMovieDB.validate_id!(id)
#       # TODO Implement reviews
#     end
#
#     def self.search(query)
#       # TODO Implement reviews
#     end
#
#     protected
#
#     def self.load_attributes(id)
#
#     end
#
#   end
# end
