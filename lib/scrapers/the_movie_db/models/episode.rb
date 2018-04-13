module TheMovieDB
  class Episode
    include NetMiner::Model
    attr_int :id, :season_number, :tv_show_id, required: true
    attr_int :episode_number, required: true
    attr_str :title, :overview, :production_code
    attr_date :air_date
    attr_ary_of Credit, :crew, :guest_stars
    attr_of NetMiner::DataTypes::Rating, :rating
    attr_ary_of NetMiner::DataTypes::Image, :screenshots
    attr_ary_of NetMiner::DataTypes::Video, :videos

    self.resources = { paths: 'http://api.themoviedb.org/3/tv/{{tv_show_id}}/season/{{season_number}}/episode/{{id}}?api_key={{api_key}}&append_to_response=videos,images', format: :json }

    def season
      Season[tv_show_id, season_number]
    end

    def tv_show
      TVShow[tv_show_id]
    end

    protected

    def self.load_attributes(id)
      tv_show_id, season_number, episode_number = id
      [tv_show_id, season_number, episode_number].each { |i| TheMovieDB.validate_id!(i) }
      response = request(:get, "#{tv_show_id}/season/#{season_number}/episode/#{episode_number}?api_key=#{TheMovieDB.api_key}&append_to_response=videos,images").keys_to_sym

      response.only(:air_date, :episode_number, :overview, :id, :production_code).tap do |attributes|
        attributes[:title]         = attributes[:name]
        attributes[:rating]        = TheMovieDB.process_rating(response)
        attributes[:guest_stars]   = TheMovieDB.process_credits(response[:guest_stars])
        attributes[:crew]          = TheMovieDB.process_credits(response[:crew])
        attributes[:screenshots]   = TheMovieDB.process_images(response[:images][:stills])
        attributes[:videos]        = TheMovieDB.process_videos(response[:videos][:results])
        attributes[:season_number] = season_number
        attributes[:tv_show_id]    = tv_show_id
      end
    end

  end
end
