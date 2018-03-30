module NetMiner
  module Mappers
    MOVIE_GENRES = Map.new(
      name: :movie_genre,
      items: [
        {
          value: 'Action',
          aliases: [
            'Action Adventure',
          ]
        },
        {
          value: 'Adult',
          aliases: [
            'Erotic', 'Porn', 'XXX', /porno/i,
          ]
        },
        {
          value: 'Adventure',
          aliases: [
            'Action Adventure',
          ]
        },
        {
          value: 'Animation',
          aliases: [
            'Cartoon',
          ]
        },
        {
          value: 'Biography',
          aliases: [
            'Biopic', 'Biographical'
          ]
        },
        {
          value: 'Comedy',
          aliases: [
            'Funny', 'Comedic', 'Parody'
          ]
        },
        {
          value: 'Crime',
          aliases: [
            'Gangster', /^crime/i, /^spy[\s$]/i,
          ]
        },
        {
          value: 'Documentary',
          aliases: [
            /^docu/i
          ]
        },
        {
          value: 'Drama',
          aliases: []
        },
        {
          value: 'Family',
          aliases: [
            'Kids', /^children/i,
          ]
        },
        {
          value: 'Fantasy',
          aliases: []
        },
        {
          value: 'Film-Noir',
          aliases: [
            'Noir',
          ]
        },
        {
          value: 'History',
          aliases: [
            /^epic/i, /^historic/i,
          ]
        },
        {
          value: 'Horror',
          aliases: [
            'Scary', 'Slasher'
          ]
        },
        {
          value: 'Music',
          aliases: []
        },
        {
          value: 'Musical',
          aliases: [
            'Dance',
          ]
        },
        {
          value: 'Mystery',
          aliases: []
        },
        {
          value: 'Romance',
          aliases: [
            'Chick Flick', 'Love', 'Romantic',
          ]
        },
        {
          value: 'Sci-Fi',
          aliases: [
            'Science Fiction', 'Science-Fiction',
          ]
        },
        {
          value: 'Sport',
          aliases: [
            'Sports',
          ]
        },
        {
          value: 'Thriller',
          aliases: [
            'Suspense',
          ]
        },
        {
          value: 'War',
          aliases: []
        },
        {
          value: 'Western',
          aliases: []
        }
      ]
    )
  end
end
