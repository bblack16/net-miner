module TheMovieDB
  class TVShow; end
  class Episode; end
  class Season
    include NetMiner::Model
    attr_int :id, :tv_show_id, required: true
    attr_date :air_date
    attr_str :title, :overview
    attr_int :season_number
    attr_int :episode_count, default_proc: proc { |x| x.episodes.size }
    attr_ary_of Credit, :crew, :cast
    attr_ary_of Episode, :episodes
    attr_ary_of NetMiner::DataTypes::Image, :posters
    attr_ary_of NetMiner::DataTypes::Video, :videos

    self.resources = { paths: 'http://api.themoviedb.org/3/tv/{{tv_show_id}}/season/{{id}}?api_key={{api_key}}&append_to_response=videos,images,credits', format: :json }

    def tv_show
      TVShow[tv_show_id]
    end

    protected

    def self.load_attributes(id)
      tv_show_id, season_number = id
      TheMovieDB.validate_id!(tv_show_id)
      TheMovieDB.validate_id!(season_number)
      response = request(:get, "#{tv_show_id}/season/#{season_number}?api_key=#{TheMovieDB.api_key}&append_to_response=videos,images,credits").keys_to_sym

      response.only(:air_date, :overview, :id, :season_number).tap do |attributes|
        attributes[:title]      = response[:name]
        attributes[:tv_show_id] = tv_show_id
        attributes[:videos]     = TheMovieDB.process_videos(response[:videos][:results])
        attributes[:posters]    = TheMovieDB.process_images(response[:images][:posters])

        [:cast, :crew].each { |type| attributes[type] = TheMovieDB.process_credits(response[:credits][type]) }

        attributes[:episodes] = response[:episodes].map do |episode|
          episode.only(:air_date, :episode_number, :overview, :id, :production_code).merge(
            title:         episode[:name],
            crew:          TheMovieDB.process_credits(episode[:crew]),
            guest_stars:   TheMovieDB.process_credits(episode[:guest_stars]),
            screenshots:   TheMovieDB.process_images(file_path: episode[:still_path]),
            rating:        TheMovieDB.process_rating(episode),
            season_number: season_number,
            tv_show_id:    tv_show_id
          )
        end
      end
    end

  end
end
