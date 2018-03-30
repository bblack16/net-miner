require 'net_miner' unless defined?(NetMiner::VERSION)

module TheGamesDb
  IMAGE_BASE = 'http://thegamesdb.net/banners/'.freeze

  {
    '3DO'                                 => { the_games_db_id: '3DO' },
    'Amiga'                               => { the_games_db_id: 'Amiga' },
    'Amstrad CPC'                         => { the_games_db_id: 'Amstrad CPC' },
    'Android'                             => { the_games_db_id: 'Android' },
    'Arcade'                              => { the_games_db_id: 'Arcade' },
    'Atari 2600'                          => { the_games_db_id: 'Atari 2600' },
    'Atari 5200'                          => { the_games_db_id: 'Atari 5200' },
    'Atari 7800'                          => { the_games_db_id: 'Atari 7800' },
    'Atari Lynx'                          => { the_games_db_id: 'Atari Lynx' },
    'Colecovision'                        => { the_games_db_id: 'Colecovision' },
    'Commodore 64'                        => { the_games_db_id: 'Commodore 64' },
    'Intellivision'                       => { the_games_db_id: 'Intellivision' },
    'Mac OS'                              => { the_games_db_id: 'Mac OS' },
    'Magnavox Odyssey 2'                  => { the_games_db_id: 'Magnavox Odyssey 2' },
    'Microsoft Xbox'                      => { the_games_db_id: 'Microsoft Xbox' },
    'Microsoft Xbox 360'                  => { the_games_db_id: 'Microsoft Xbox 360' },
    'Microsoft Xbox One'                  => { the_games_db_id: 'Microsoft Xbox One' },
    'Neo Geo Pocket'                      => { the_games_db_id: 'Neo Geo Pocket' },
    'Neo Geo Pocket Color'                => { the_games_db_id: 'Neo Geo Pocket Color' },
    'NeoGeo'                              => { the_games_db_id: 'NeoGeo' },
    'Nintendo 3DS'                        => { the_games_db_id: 'Nintendo 3DS' },
    'Nintendo 64'                         => { the_games_db_id: 'Nintendo 64' },
    'Nintendo DS'                         => { the_games_db_id: 'Nintendo DS' },
    'Nintendo Entertainment System'       => { the_games_db_id: 'Nintendo Entertainment System (NES)' },
    'Nintendo Game Boy'                   => { the_games_db_id: 'Nintendo Game Boy' },
    'Nintendo Game Boy Advance'           => { the_games_db_id: 'Nintendo Game Boy Advance' },
    'Nintendo Game Boy Color'             => { the_games_db_id: 'Nintendo Game Boy Color' },
    'Nintendo GameCube'                   => { the_games_db_id: 'Nintendo GameCube' },
    'Nintendo Virtual Boy'                => { the_games_db_id: 'Nintendo Virtual Boy' },
    'Nintendo Wii'                        => { the_games_db_id: 'Nintendo Wii' },
    'Nintendo Wii U'                      => { the_games_db_id: 'Nintendo Wii U' },
    'Ouya'                                => { the_games_db_id: 'Ouya' },
    'PC'                                  => { the_games_db_id: 'PC' },
    'Philips CD-i'                        => { the_games_db_id: 'Philips CD-i' },
    'Sega 32X'                            => { the_games_db_id: 'Sega 32X' },
    'Sega CD'                             => { the_games_db_id: 'Sega CD' },
    'Sega Dreamcast'                      => { the_games_db_id: 'Sega Dreamcast' },
    'Sega Game Gear'                      => { the_games_db_id: 'Sega Game Gear' },
    'Sega Genesis'                        => { the_games_db_id: 'Sega Genesis' },
    'Sega Master System'                  => { the_games_db_id: 'Sega Master System' },
    'Sega Saturn'                         => { the_games_db_id: 'Sega Saturn' },
    'Sony Playstation'                    => { the_games_db_id: 'Sony Playstation' },
    'Sony Playstation 2'                  => { the_games_db_id: 'Sony Playstation 2' },
    'Sony Playstation 3'                  => { the_games_db_id: 'Sony Playstation 3' },
    'Sony Playstation 4'                  => { the_games_db_id: 'Sony Playstation 4' },
    'Sony Playstation Vita'               => { the_games_db_id: 'Sony Playstation Vita' },
    'Sony PSP'                            => { the_games_db_id: 'Sony PSP' },
    'Super Nintendo Entertainment System' => { the_games_db_id: 'Super Nintendo (SNES)' },
    'TurboGrafx 16'                       => { the_games_db_id: 'TurboGrafx 16' },
    'WonderSwan'                          => { the_games_db_id: 'WonderSwan' },
    'WonderSwan Color'                    => { the_games_db_id: 'WonderSwan Color' }
  }.each do |platform, attributes|
    NetMiner::Mappings::VIDEOGAME_PLATFORMS.add_attributes(platform, attributes)
  end
end

require_relative 'the_games_db/models/platform'
require_relative 'the_games_db/models/game'
