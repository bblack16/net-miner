module TheGamesDb
  class Game
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :title, :esrb, allow_nil: true
    attr_str :overview, :developer, :publisher, allow_nil: true
    attr_ary_of String, :genres
    attr_int_between 1, nil, :players, default: 1
    attr_bool :coop, pre_proc: proc { |x| x.to_s.downcase.strip == 'yes' }
    attr_date :release, formats: ['%m/%d/%Y'], allow_nil: true
    attr_of NetMiner::DataTypes::Video, :trailer, allow_nil: true
    attr_of NetMiner::DataTypes::Rating, :rating, allow_nil: true
    attr_ary_of NetMiner::DataTypes::Image, :fanart, :banners, :screenshots, :covers, :back_covers, :logos
    attr_of Platform, :platform, allow_nil: true

    self.base_url = 'http://thegamesdb.net/api'
    self.default_format = :xml

    GAME_ATTRIBUTES = {
      id:        'id',
      title:     'GameTitle',
      release:   'ReleaseDate',
      overview:  'Overview',
      esrb:      'ESRB',
      trailer:   'Youtube',
      publisher: 'Publisher',
      developer: 'Developer',
      rating:    'Rating',
      players:   'Players',
      coop:      'Co-op'
    }.freeze

    SPECIAL = ['Genres', 'Similar']

    GAME_IMAGES = {
      logos:       'clearlogo',
      covers:      'boxart[@side="front"]',
      back_covers: 'boxart[@side="back"]',
      banners:     'banner'
    }.freeze

    def self.[](id)
      raise ArgumentError, "Invalid ID for TheGamesDB Platform. Should be an integer or integer string not #{id}." unless id.is_a?(Integer) || id =~ /^\d+$/

      response = request(:get, "/GetGame.php?id=#{id}")

      args = GAME_ATTRIBUTES.hmap do |name, path|
        [
          name,
          response.xpath("/Data/Game/#{path}").first&.text
        ]
      end.reject { |k, v| v.nil? }

      args[:platform] = {
        id: response.xpath('/Data/Game/PlatformId').text,
        name: response.xpath('/Data/Game/Platform').text
      }

      args[:genres] = response.xpath('/Data/Game/Genres/genre').map(&:text)

      # Scrape fanart and screenshots
      { fanart: 'fanart', screenshots: 'screenshot' }.each do |type, path|
        args[type] = response.xpath("/Data/Game/Images/#{path}").map do |node|
          {
            url:       "#{IMAGE_BASE}#{node.xpath('original').text}",
            thumbnail: "#{IMAGE_BASE}#{node.xpath('thumb').text}",
            width:     node.xpath('original/@width').text,
            height:    node.xpath('original/@height').text
          }
        end
      end

      GAME_IMAGES.each do |type, path|
        args[type] = response.xpath("/Data/Game/Images/#{path}").map do |node|
          {
            url:    "#{IMAGE_BASE}#{node.text}",
            width:  node.xpath('@width').text,
            height: node.xpath('@height').text
          }
        end
      end

      Game.new(args.merge(scraped: true, score: 100))
    end

    def self.all
      raise RuntimeError, "TheGamesDb Games cannot be retrieved using all. Please use search and search by title."
    end

    def self.search(query, platform = nil)
      platform = NetMiner::Mappings.match(:videogame_platform, platform, :the_games_db_id) || platform if platform
      response = request(:get, "/GetGamesList.php?name=#{query}#{platform ? "&platform=#{platform}" : nil}")
      response.xpath('/Data/Game').map do |node|
        Game.new(
          id:      node.xpath('id').text.to_i,
          title:   node.xpath('GameTitle').text,
          release: node.xpath('ReleaseDate').text,
          score:   matcher.similarity(query, node.xpath('GameTitle').text)
        )
      end.sort_by { |result| result.score }.reverse
    end

  end
end
