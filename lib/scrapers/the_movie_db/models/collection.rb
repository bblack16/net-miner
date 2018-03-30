module TheMovieDB
  class Collection
    include NetMiner::Model

    attr_int :id, required: true
    attr_str :title, :overview
    attr_ary_of NetMiner::Model, :movies
    attr_of NetMiner::DataTypes::Image, :poster, :backdrop

  end
end
