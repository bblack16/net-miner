module TheGamesDB
  class Game
    include NetMiner::Model
    attr_int :id, required: true, net_miner_path: '/Data/Game/id', net_miner_search_path: '/Data/Game/id'
    attr_str :title, allow_nil: true, net_miner_path: '/Data/Game/GameTitle', net_miner_search_path: '/Data/Game/GameTitle'
    attr_str :esrb, allow_nil: true, net_miner_path: '/Data/Game/ESRB'
    attr_str :overview, allow_nil: true, net_miner_path: '/Data/Game/Overview'
    attr_str :publisher, allow_nil: true, net_miner_path: '/Data/Game/Publisher'
    attr_str :developer, allow_nil: true, net_miner_path: '/Data/Game/Developer'
    attr_ary_of String, :genres, net_miner_path: '/Data/Game/Genres/genre'
    attr_int_between 1, nil, :players, default: 1, net_miner_path: '/Data/Game/Players'
    attr_bool :coop, pre_proc: proc { |x| x.to_s.downcase.strip == 'yes' }, net_miner_path: '/Data/Game/Co-op'
    attr_date :release, formats: ['%m/%d/%Y'], allow_nil: true, net_miner_path: '/Data/Game/ReleaseDate', net_miner_search_path: '/Data/Game/ReleaseDate'
    attr_of NetMiner::DataTypes::Video, :trailer, allow_nil: true, net_miner_path: '/Data/Game/Youtube'
    attr_of NetMiner::DataTypes::Rating, :rating, allow_nil: true
    attr_ary_of NetMiner::DataTypes::Image, :fanart, :banners, :screenshots, :covers, :back_covers, :logos
    attr_of Platform, :platform, allow_nil: true

    self.resources = { paths: 'http://TheGamesDB.net/api/GetGame.php?id={{id}}', format: :xml }
    self.search_resource = { paths: ['http://TheGamesDB.net/api/GetGamesList.php?name={{query}}','http://TheGamesDB.net/api/GetGamesList.php?name={{query}}&platform={{platform}}'], format: :xml }
    self.search_field = :title

    GAME_IMAGES = {
      logos:       'clearlogo',
      covers:      'boxart[@side="front"]',
      back_covers: 'boxart[@side="back"]',
      banners:     'banner'
    }.freeze

    protected

    def self.process_query(query)
      query[:platform] = NetMiner::Mappings.match(:videogame_platform, query[:platform], :the_games_db_id) || query[:platform] if query[:platform]
    end

    def self.load_attributes(attributes, pages)
      response = pages.main

      attributes[:platform] = {
        id:   response.extract_one('/Data/Game/PlatformId'),
        name: response.extract_one('/Data/Game/Platform')
      }

      # Scrape fanart and screenshots
      { fanart: 'fanart', screenshots: 'screenshot' }.each do |type, path|
        attributes[type] = response.extract_node("/Data/Game/Images/#{path}").map do |node|
          {
            url:       "#{IMAGE_BASE}#{node.xpath('original')}",
            thumbnail: "#{IMAGE_BASE}#{node.xpath('thumb')}",
            width:     node.xpath('original/@width').text,
            height:    node.xpath('original/@height').text
          }
        end
      end

      GAME_IMAGES.each do |type, path|
        attributes[type] = response.extract_node("/Data/Game/Images/#{path}").map do |node|
          {
            url:    "#{IMAGE_BASE}#{node}",
            width:  node.xpath('@width').text,
            height: node.xpath('@height').text
          }
        end
      end
    end

  end
end
