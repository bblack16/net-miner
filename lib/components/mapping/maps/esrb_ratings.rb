module NetMiner
  module Mappers
    ESRB_RATINGS = Map.new(
      name: :esrb_ratings,
      items: [
        {
          value: 'EC - Early Childhood',
          aliases: [
            'Ec', /early childhood/i
          ]
        },
        {
          value: 'E - Everyone',
          aliases: [
            'E - Everyone', 'E', 'Everyone'
          ]
        },
        {
          value: 'E10+ - Everyone',
          aliases: [
            'E10+', 'Everyone 10+', /^e ten/i, /^e\s?10/, /^everyone 10/i,
            /^everyone ten/i
          ]
        },
        {
          value: 'T - Teen',
          aliases: [
            'T', /teen/i
          ]
        },
        {
          value: 'M - Mature',
          aliases: [
            'M', /mature/i
          ]
        },
        {
          value: 'A - Adult',
          aliases: [
            'A', /adult/i
          ]
        },
        {
          value: 'RP - Rating Pending',
          aliases: [
            'Rp', /not rated/i, /pending/i
          ]
        }
      ]
    )
  end
end
