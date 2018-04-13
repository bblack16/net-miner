module TheGamesDB
  class Platform
    include NetMiner::Model

    attr_int :id, required: true, net_miner_path: '/Data/Platform/id', net_miner_search_path: '/Data/Platforms/Platform/id'
    attr_str :name, net_miner_path: '/Data/Platform/Platform', net_miner_search_path: '/Data/Platforms/Platform/name'
    attr_str :overview, allow_nil: true, net_miner_path: '/Data/Platform/overview'
    attr_str :developer, allow_nil: true, net_miner_path: '/Data/Platform/developer'
    attr_str :manufacturer, allow_nil: true, net_miner_path: '/Data/Platform/manufacturer'
    attr_str :cpu, allow_nil: true, net_miner_path: '/Data/Platform/cpu'
    attr_str :memory, allow_nil: true, net_miner_path: '/Data/Platform/memory'
    attr_str :graphics, allow_nil: true, net_miner_path: '/Data/Platform/graphics'
    attr_str :sound, allow_nil: true, net_miner_path: '/Data/Platform/sound'
    attr_str :display, allow_nil: true, net_miner_path: '/Data/Platform/display'
    attr_str :media, allow_nil: true, net_miner_path: '/Data/Platform/media'
    attr_int_between 1, nil, :max_controllers, default: 1, net_miner_path: '/Data/Platform/maxcontrollers'
    attr_of NetMiner::DataTypes::Video, :trailer, allow_nil: true
    attr_of NetMiner::DataTypes::Rating, :rating, allow_nil: true
    attr_ary_of NetMiner::DataTypes::Image, :fanart, :banners, :covers, :back_covers, :console_art, :controller_art

    self.resources = { paths: 'http://TheGamesDB.net/api/GetPlatform.php?id={{id}}', format: :xml }
    self.search_resource = { paths: 'http://TheGamesDB.net/api/GetPlatformsList.php', format: :xml }
    self.search_field = :name

    PLATFORM_IMAGES = {
      console_art:    'consoleart',
      controller_art: 'controllerart',
      covers:         'boxart[@side="front"]',
      back_covers:    'boxart[@side="back"]'
    }.freeze

    def self.all
      response = request(:get, '/GetPlatformsList.php')
      response.xpath('/Data/Platforms/Platform').map do |node|
        new(id: node.xpath('id').first.text.to_i, name: node.xpath('name').first.text)
      end
    end

    def games
      response = request(:get, "/PlatformGames.php?platform=#{name}")
      response.xpath('/Data/Game').map do |node|
        Game.new(id: node.xpath('id').first.text.to_i, title: node.xpath('GameTitle').first.text)
      end
    end

    protected

    def self.load_attributes(attributes, pages = {})
      response = pages.main

      # Scrape fanart
      attributes[:fanart] = response.extract_node("/Data/Platform/Images/fanart").map do |node|
        {
          url:       "#{IMAGE_BASE}#{node.xpath('original').text}",
          thumbnail: "#{IMAGE_BASE}#{node.xpath('thumb').text}",
          width:     node.xpath('original/@width').text,
          height:    node.xpath('original/@height').text
        }
      end

      # Scrape banners
      attributes[:banners] = response.extract_node("/Data/Platform/Images/banner").map do |node|
        {
          url:    "#{IMAGE_BASE}#{node.text}",
          width:  node.xpath('@width').text,
          height: node.xpath('@height').text
        }
      end

      # Scrape all other images other than fanart
      PLATFORM_IMAGES.each do |type, path|
        response.extract_node("/Data/Platform/Images/#{path}").each do |node|
          attributes[type] = {
            url:    "#{IMAGE_BASE}#{node.text}",
            width:  node.xpath('@width').text,
            height: node.xpath('@height').text
          }
        end
      end

      attributes
    end

  end
end
