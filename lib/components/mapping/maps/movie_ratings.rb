module NetMiner
  module Mappers
    MOVIE_RATINGS = Map.new(
      name: :movie_ratings,
      items: [
        {
          value: 'G',
          aliases: [
            'All Ages', 'General Audiences', 'General'
          ]
        },
        {
          value: 'PG',
          aliases: [
            /^parent guidance/i
          ]
        },
        {
          value: 'PG-13',
          aliases: [
            'Pg 13', 'Pg13', /^parents cautioned/i
          ]
        },
        {
          value: 'R',
          aliases: [
            'Restricted'
          ]
        },
        {
          value: 'NC-17',
          aliases: [
            'Adult', 'Adults Only'
          ]
        },
        {
          value: 'Unrated',
          aliases: [
            '', 'No Rating', 'None'
          ]
        }
      ]
    )
  end
end
