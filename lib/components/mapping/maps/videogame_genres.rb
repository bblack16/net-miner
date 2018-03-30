module NetMiner
  module Mappers
    VIDEOGAME_GENRES = Map.new(
      name: :videogame_genre,
      items: [
        {
          value: 'Action',
          aliases: [
            'Action Adventure', 'Fighter', 'Fighting', 'Platform', 'Stealth',
            'Survival', /beat \'?em up/i, /shooter/i
          ]
        },
        {
          value: 'Adventure',
          aliases: [
            'Interactive Movie', 'Visual Novel', /adventure$/, /point (and|&|n) click/i
          ]
        },
        {
          value: 'Role-Playing',
          aliases: [
            'Fantasy', 'MMORPG', 'RPG', 'Role Playing Game', /roguelike/i,
            /rpg$/i
          ]
        },
        {
          value: 'Simulation',
          aliases: [
            'Flight', /management/i, /simulat/i
          ]
        },
        {
          value: 'Strategy',
          aliases: [
            '4x', 'Artillery', 'Moba', 'Multiplayer Online Battle Arena', 'Real Time Strategy',
            'Real Time Tactics', 'Rts', 'Rtt', 'TBS', 'TBT',
            'Tower Defense', 'Turn Based Strategy', 'Turn Based Tactics', /strategy$/i, /wargame/i
          ]
        },
        {
          value: 'Sports',
          aliases: [
            'Racing', 'Sport'
          ]
        },
        {
          value: 'Music',
          aliases: [
            /guitar/i, /rythm/i
          ]
        },
        {
          value: 'Puzzle',
          aliases: []
        },
        {
          value: 'Party',
          aliases: [
            'Trivia'
          ]
        },
        {
          value: 'Board & Card',
          aliases: [
            'Board Game', 'Board', 'Card Game', 'Card'
          ]
        },
        {
          value: 'Education',
          aliases: [
            'Educational'
          ]
        },
        {
          value: 'Other',
          aliases: [
            'Unknown'
          ]
        }
      ]
    )
  end
end
