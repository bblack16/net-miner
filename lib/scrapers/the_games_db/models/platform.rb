module TheGamesDb
  class Platform
    include NetMiner::Model
    attr_int :id, required: true
    attr_str :name
    attr_str :overview, :developer, :manufacturer, :cpu, :memory, allow_nil: true
    attr_str :graphics, :sound, :display, :media, allow_nil: true
    attr_of NetMiner::DataTypes::Video, :trailer, allow_nil: true
    attr_int_between 1, nil, :max_controllers, default: 1
    attr_of NetMiner::DataTypes::Rating, :rating, allow_nil: true
    attr_ary_of NetMiner::DataTypes::Image, :fanart, :banners, :covers, :back_covers, :console_art, :controller_art


    self.base_url = 'http://thegamesdb.net/api'
    self.default_format = :xml

    PLATFORM_ATTRIBUTES = {
      id:              'id',
      name:            'Platform',
      overview:     'overview',
      developer:       'developer',
      manufacturer:    'manufacturer',
      cpu:             'cpu',
      memory:          'memory',
      graphics:        'graphics',
      sound:           'sound',
      display:         'display',
      media:           'media',
      max_controllers: 'maxcontrollers',
      trailer:         'Youtube',
      rating:          'Rating'
    }.freeze

    PLATFORM_IMAGES = {
      console_art:    'consoleart',
      controller_art: 'controllerart',
      covers:          'boxart[@side="front"]',
      back_covers:     'boxart[@side="back"]'
    }.freeze

    def self.[](id)
      raise ArgumentError, "Invalid ID for TheGamesDB Platform. Should be an integer or integer string not #{id}." unless id.is_a?(Integer) || id =~ /^\d+$/

      # Make call to API
      response = request(:get, "/GetPlatform.php?id=#{id}")

      # Retrieve entries
      args = PLATFORM_ATTRIBUTES.hmap do |key, path|
        value = response.xpath("/Data/Platform/#{path}").first
        next unless value
        [
          key,
          value.text
        ]
      end

      # Scrape fanart
      args[:fanart] = response.xpath("/Data/Platform/Images/fanart").map do |node|
        {
          url:       "#{IMAGE_BASE}#{node.xpath('original').text}",
          thumbnail: "#{IMAGE_BASE}#{node.xpath('thumb').text}",
          width:     node.xpath('original/@width').text,
          height:    node.xpath('original/@height').text
        }
      end

      # Scrape banners
      args[:banners] = response.xpath("/Data/Platform/Images/banner").map do |node|
        {
          url:    "#{IMAGE_BASE}#{node.text}",
          width:  node.xpath('@width').text,
          height: node.xpath('@height').text
        }
      end

      # Scrape all other images other than fanart
      PLATFORM_IMAGES.each do |type, path|
        response.xpath("/Data/Platform/Images/#{path}").each do |node|
          args[type] = {
            url:    "#{IMAGE_BASE}#{node.text}",
            width:  node.xpath('@width').text,
            height: node.xpath('@height').text
          }
        end
      end

      Platform.new(args.merge(scraped: true, score: 100))
    end

    def self.all
      response = request(:get, '/GetPlatformsList.php')
      response.xpath('/Data/Platforms/Platform').map do |node|
        Platform.new(id: node.xpath('id').first.text.to_i, name: node.xpath('name').first.text)
      end
    end

    def games
      response = request(:get, "/PlatformGames.php?platform=#{name}")
      response.xpath('/Data/Game').map do |node|
        Game.new(id: node.xpath('id').first.text.to_i, title: node.xpath('GameTitle').first.text)
      end
    end

  end
end
