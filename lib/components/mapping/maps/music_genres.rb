module NetMiner
  module Mappers
    MUSIC_GENRES = Map.new(
      name: :music_genre,
      items: [
        {
          value: 'African',
          aliases: [
            'African Heavy Metal', 'African Hip Hop', 'Afrobeat', 'Apala', 'Benga', 
            'Bikutsi', 'Bongo Flava', 'Cape Jazz', 'Chimurenga', 'Congolese Rumba',
            'Coupé-Décalé', 'Fuji Music', 'Genge', 'Highlife', 'Hiplife',
            'Igbo Highlife', 'Igbo Rap', 'Isicathamiya', 'Jit', 'Jùjú',
            'Kadongo Kamu', 'Kapuka Aka Boomba', 'Kizomba', 'Kuduro', 'Kwaito',
            'Kwassa Kwassa', 'Kwela', 'Makossa', 'Maloya', 'Marrabenta',
            'Mbalax', 'Mbaqanga', 'Mbube', 'Morna', 'Ndombolo',
            'Palm-Wine', 'Raï', 'Sakara', 'Sega', 'Seggae',
            'Semba', 'Shangaan Electro', 'Soukous', 'Taarab', 'Zouglou Cote D\'Ivoire',   ]
        },
        {
          value: 'Asian',
          aliases: [
            'Anison', 'Baila', 'Baul', 'Bhangra', 'C-Pop',
            'Cantopop', 'Dangdut', 'East Asian', 'Enka', 'Fann At-Tanbura',
            'Fijiri', 'Filmi', 'Gamelan', 'Hong Kong English Pop', 'Indian Pop',
            'J-Pop', 'J-Rock', 'K-Pop', 'Kayokyoku', 'Keroncong',
            'Khaliji', 'Lavani', 'Liwa', 'Luk Krung', 'Luk Thung',
            'Mandopop', 'Manila Sound', 'Morlam', 'Onkyokei', 'Original Pilipino Music',
            'P-Pop', 'Pinoy Pop', 'Pop Sunda', 'Ragini', 'Sawt',
            'South and Southeast Asian', 'Taiwanese Pop', 'Thai Pop', 'V-Pop',   ]
        },
        {
          value: 'Avant-Garde',
          aliases: [
            'Avant Garde', 'Electroacoustic', 'Experimental Music', 'Lo-Fi', 'Musique Concrète',
            'Noise',   ]
        },
        {
          value: 'Blues',
          aliases: [
            'African Blues', 'Blues Rock', 'Blues Shouter', 'British Blues', 'Canadian Blues',
            'Chicago Blues', 'Classic Female Blues', 'Contemporary R&B', 'Country Blues', 'Delta Blues',
            'Detroit Blues', 'Electric Blues', 'Gospel Blues', 'Hill Country Blues', 'Hokum Blues',
            'Jump Blues', 'Kansas City Blues', 'Louisiana Blues', 'Memphis Blues', 'Piedmont Blues',
            'Punk Blues', 'Rhythm and Blues', 'Soul Blues', 'St. Louis Blues', 'Swamp Blues',
            'Texas Blues', 'West Coast Blues', /\sblues$/i,   ]
        },
        {
          value: 'Carribean',
          aliases: [
            '2 Tone', 'Baithak Gana', 'Bouyon', 'Cadence-Lypso', 'Calypso',
            'Cha Cha Cha', 'Chutney Soca', 'Chutney', 'Compas', 'Dancehall Music',
            'Dancehall', 'Dub', 'Lovers Rock', 'Mambo', 'Merengue',
            'Mosambique', 'Méringue', 'Punta Rock', 'Punta', 'Ragga Jungle',
            'Ragga', 'Rasin', 'Reggae Fusion', 'Reggae', 'Reggaeton',
            'Rocksteady', 'Rumba', 'Salsa', 'Ska Punk', 'Ska',
            'Soca', 'Son Cubano', 'Songo', 'Timba', 'Twoubadou',
            'Zouk',   ]
        },
        {
          value: 'Classical',
          aliases: [
            'Ball Room', 'Ballroom', 'Orchesta', 'Symphony',   ]
        },
        {
          value: 'Comedy',
          aliases: [
            'Comedy Rock', 'Garel Eglas', 'Novelty Music', 'Parody Music', 'Stand Up',
            'Stand-Up',   ]
        },
        {
          value: 'Country',
          aliases: [
            'Alternative Country', 'Americana', 'Australian Country Music', 'Bakersfield Sound', 'Bluegrass',
            'Blues Country', 'Cajun Fiddle Tunes', 'Cajun', 'Christian Country Music', 'Classic Country',
            'Close Harmony', 'Country Pop', 'Country Rap', 'Country Rock', 'Cowpunk',
            'Dansband Music', 'Franco-Country', 'Hellbilly Music', 'Hokum', 'Honky Tonk',
            'Instrumental Country', 'Nashville Sound', 'Neotraditional Country', 'Outlaw Country', 'Progressive Bluegrass',
            'Progressive Country', 'Psychobilly/Punkabilly', 'Reactionary Bluegrass', 'Red Dirt', 'Rockabilly',
            'Sertanejo', 'Texas Country', 'Traditional Country Music', 'Truck-Driving Country', 'Western Swing',
            'Zydeco',   ]
        },
        {
          value: 'Easy Listening',
          aliases: [
            'Background Music', 'Beautiful Music', 'Elevator Music', 'Furniture Music', 'Lounge Music',
            'Middle Of the Road', 'New-Age Music',   ]
        },
        {
          value: 'Electronic',
          aliases: [
            '', '2-Step Garage', '4-Beat', 'Acid Breaks', 'Acid House',
            'Acid Jazz', 'Acid Techno', 'Acid Trance', 'Acousmatic Music', 'Afro / Cosmic Disco',
            'Aggrotech', 'Alternative Dance', 'Ambient Dub', 'Ambient House', 'Ambient',
            'Asian Underground', 'Balearic Beat', 'Balearic Trance', 'Baltimore Club', 'Bassline/4x4 Garage',
            'Berlin School', 'Big Beat', 'Big Room', 'Bitpop', 'Boogie',
            'Bouncy House', 'Bouncy Techno', 'Breakbeat Hardcore', 'Breakbeat', 'Breakcore',
            'Breakstep', 'Broken Beat', 'Brostep', 'Bubblegum Dance', 'Chicago House',
            'Chill-Out', 'Chillstep', 'Chillwave', 'Chiptune', 'Coldwave',
            'Complextro', 'Cybergrind', 'Dance-Punk', 'Dance-Rock', 'Dark Ambient',
            'Dark Electro', 'Dark Wave', 'Darkcore Jungle', 'Darkcore', 'Darkstep',
            'Death Industrial', 'Deep House', 'Detroit Techno', 'Digital Hardcore', 'Disco Polo',
            'Disco', 'Diva House/Handbag House', 'Doomcore', 'Downtempo', 'Dream Trance',
            'Drill and Bass', 'Drone Music', 'Drum and Bass', 'Drumstep', 'Dub Techno',
            'Dub', 'Dubstep', 'Dubstyle', 'Dubtronica', 'Dutch House',
            'EDM', 'Electro House', 'Electro Music', 'Electro Swing', 'Electro-Industrial',
            'Electroacoustic Music', 'Electroclash', 'Electronic Body Music', 'Electronic Rock', 'Electronica',
            'Electronicore', 'Electropunk', 'Ethereal Wave', 'Ethnic Electronica', 'Euro Disco',
            'Eurobeat', 'Eurodance', 'Fidget House', 'Florida Breaks', 'Folktronica',
            'Free Tekno', 'Freestyle Music', 'French House', 'Full on', 'Funkstep',
            'Funktronica', 'Funky House', 'Future Garage', 'Future House', 'Futurepop',
            'Gabba', 'Game Boy Music', 'Garage House', 'Ghetto House', 'Ghettotech',
            'Glitch Hop', 'Glitch', 'Goa Trance', 'Grindie', 'Happy Hardcore',
            'Hard House', 'Hard NRG', 'Hard Trance', 'Hardbag', 'Hardstep',
            'Hardstyle', 'Hi-NRG', 'Hip House', 'House Music', 'IDM',
            'Illbient', 'Indietronica', 'Industrial Metal', 'Industrial Music', 'Industrial Rock',
            'Isolationism', 'Italo Dance', 'Italo Disco', 'Italo House', 'Japanoise',
            'Jazz House', 'Jersey Club', 'Jump-Up', 'Jumpstyle', 'Jungle',
            'Krautrock', 'Kwaito', 'Laptronica', 'Latin House', 'Lento Violento',
            'Liquid Dubstep', 'Liquid Funk', 'Livetronica', 'Lowercase', 'Melbourne Bounce',
            'Miami Bass', 'Microhouse/Minimal House', 'Minimal Techno', 'Minimal Wave', 'Moombahcore',
            'Moombahton', 'Musique Concrète', 'Mákina', 'Neue Deutsche Härte', 'Neurofunk',
            'Neurohop', 'New Beat', 'New Rave', 'New-Age Music', 'Nintendocore',
            'Nitzhonot', 'Nortec', 'Nu Skool Breaks', 'Nu-Disco', 'Nu-Funk',
            'Nu-Gaze', 'Nu-NRG', 'Outsider House', 'Post-Disco', 'Power Electronics',
            'Power Noise', 'Progressive House', 'Progressive Trance', 'Psybient', 'Psychedelic Trance',
            'Raggacore', 'Rara Tech', 'Reggaestep', 'Sambass', 'Skweee',
            'Space Disco', 'Space Music', 'Space Rock', 'Speed Garage', 'Speedcore',
            'Suomisaundi', 'Synthpop', 'Synthwave', 'Tech House', 'Tech Trance',
            'Techdombe', 'Techno', 'Techstep', 'Tecno Brega', 'Trance Music',
            'Trapstep', 'Tribal House', 'Trip Hop', 'Trival', 'Tropical House',
            'UK Funky', 'UK Garage', 'UK Hardcore', 'Uplifting Trance', 'Vaporwave',
            'Video Game Music', 'Vocal Trance', 'Witch House', 'Wonky', /[\s\_\-]dance/i,   ]
        },
        {
          value: 'Folk',
          aliases: [
            'American Folk Revival', 'Anti-Folk', 'British Folk Revival', 'Celtic Music', 'Chalga',
            'Contemporary Folk', 'Cowboy/Western Music', 'Filk Music', 'Folktronica', 'Freak Folk',
            'Indie Folk', 'Industrial Folk', 'Neofolk', 'Progressive Folk', 'Protest Song',
            'Psychedelic Folk', 'Singer-Songwriter Movement', 'Skiffle', 'Sung Poetry',   ]
        },
        {
          value: 'Hip Hop',
          aliases: [
            'Alternative Hip Hop', 'Atlanta Hip Hop', 'Australian Hip Hop', 'Baltimore Club', 'Bongo Flava',
            'Bounce Music', 'Brick City Club', 'Bristol Sound', 'British Hip Hop', 'Chap Hop',
            'Chicago Hip Hop', 'Chicano Rap', 'Chopped and Screwed', 'Christian Hip Hop', 'Conscious Hip Hop',
            'Country-Rap', 'Crunk', 'Crunkcore', 'Cumbia Rap', 'Detroit Hip Hop',
            'Drill', 'East Coast Hip Hop', 'Electro Music', 'Experimental Hip Hop', 'Freestyle Rap',
            'G-Funk', 'Gangsta Rap', 'Ghetto House', 'Ghettotech', 'Golden Age Hip Hop',
            'Grime', 'Hardcore Hip Hop', 'Hip House', 'Hip Pop', 'Hiplife',
            'Horrorcore', 'Houston Hip Hop', 'Hyphy', 'Igbo Rap', 'Industrial Hip Hop',
            'Instrumental Hip Hop', 'Jazz Rap', 'Jerkin\'', 'Kwaito', 'Low Bap',
            'Lyrical Hip Hop', 'Mafioso Rap', 'Merenrap', 'Miami Bass', 'Midwest Hip Hop',
            'Motswako', 'Nerdcore', 'New Jack Swing', 'New Jersey Hip Hop', 'New School Hip Hop',
            'Old School Hip Hop', 'Political Hip Hop', 'Ragga', 'Rap Music', 'Rap Opera',
            'Reggae Español/Spanish Reggae', 'Reggaeton', 'Snap Music', 'Songo-Salsa', 'Southern Hip Hop',
            'St. Louis Hip Hop', 'Trap', 'Trip Hop', 'Turntablism', 'Twin Cities Hip Hop',
            'Underground Hip Hop', 'Urban Pasifika', 'West Coast Hip Hop', /(^|\s)hip[\s\-]hop($|\s)/i, /gangsta/i,
            /rap$/i,   ]
        },
        {
          value: 'Jazz',
          aliases: [
            'Acid Jazz', 'Afro-Cuban Jazz', 'Asian American Jazz', 'Avant-Garde Jazz', 'Bebop',
            'Boogie-Woogie', 'Bossa Nova', 'British Dance Band', 'Cape Jazz', 'Chamber Jazz',
            'Continental Jazz', 'Cool Jazz', 'Crossover Jazz', 'Dixieland', 'Ethno Jazz',
            'European Free Jazz', 'Free Funk', 'Free Improvisation', 'Free Jazz', 'Gypsy Jazz',
            'Hard Bop', 'Jazz Blues', 'Jazz Fusion', 'Jazz Rap', 'Jazz Rock',
            'Jazz-Funk', 'Kansas City Blues', 'Kansas City Jazz', 'Latin Jazz', 'Livetronica',
            'M-Base', 'Mainstream Jazz', 'Modal Jazz', 'Neo-Bop Jazz', 'Neo-Swing',
            'Novelty Ragtime', 'Nu Jazz', 'Orchestral Jazz', 'Post-Bop', 'Punk Jazz',
            'Ragtime', 'Shibuya-Kei', 'Ska Jazz', 'Smooth Jazz', 'Soul Jazz',
            'Straight-Ahead Jazz', 'Stride Jazz', 'Swing', 'Third Stream', 'Trad Jazz',
            'Vocal Jazz', 'West Coast Jazz',   ]
        },
        {
          value: 'Latin',
          aliases: [
            'Afro-Cuban Jazz', 'Axé', 'Bachata', 'Banda', 'Bolero',
            'Bossa Nova', 'Brazilian Rock', 'Brazilian', 'Brega', 'Bullerengue',
            'Chicha', 'Choro', 'Criolla', 'Cumbia', 'Fado',
            'Flamenco', 'Folk', 'Forró', 'Frevo', 'Funk Carioca',
            'Grupera', 'Guajira', 'Huayno', 'Lambada', 'Latin Alternative',
            'Latin Ballad', 'Latin Christian', 'Latin Jazz', 'Latin Pop', 'Latin Rock',
            'Latin Swing', 'Mambo', 'Maracatu', 'Mariachi', 'Merengue',
            'Mexican Son', 'Música Criolla', 'Música Popular Brasileira', 'Música Sertaneja', 'Norteño',
            'Nueva Canción', 'Pagode', 'Porro', 'Ranchera', 'Reggaeton',
            'Regional Mexican', 'Rock En Español', 'Rumba', 'Salsa Romántica', 'Salsa',
            'Samba Rock', 'Samba', 'Son', 'Tango', 'Tecnobrega',
            'Tejano', 'Timba', 'Traditional:', 'Tropical', 'Tropicalia',
            'Tropipop', 'Vallenato', 'Zouk-Lambada',   ]
        },
        {
          value: 'Metal',
          aliases: [
            'Alternative Metal', 'Avant-Garde Metal', 'Black Metal', 'Brutal Death Metal', 'Celtic Metal',
            'Christian Metal', 'Crossover Thrash', 'Crustgrind', 'Death Metal', 'Death \'N\' Roll',
            'Death-Doom', 'Deathcore', 'Djent', 'Doom Metal', 'Drone Metal',
            'Folk Metal', 'Funk Metal', 'Glam Metal', 'Goregrind', 'Gothic Metal',
            'Grindcore', 'Groove Metal', 'Hardcore', 'Heavy Metal', 'Industrial Metal',
            'Latin Metal', 'Mathcore', 'Medieval Metal', 'Melodic Death Metal', 'Melodic Metalcore',
            'Metalcore', 'Neoclassical Metal', 'Noisegrind', 'Nu Metal', 'Pagan Metal',
            'Post-Hardcore', 'Post-Metal', 'Power Metal', 'Powerviolence', 'Progressive Metal',
            'Rap Metal', 'Rapcore', 'Screamo', 'Sludge Metal', 'Speed Metal',
            'Symphonic Black Metal', 'Symphonic Metal', 'Technical Death Metal', 'Thrash Metal', 'Thrashcore',
            'Unblack Metal', 'Viking Metal', 'War Metal', /[\s\_\-]metal$/i,   ]
        },
        {
          value: 'Pop',
          aliases: [
            'Adult Contemporary', 'Arab Pop', 'Austropop', 'Baroque Pop', 'Brill Building',
            'Britpop', 'Bubblegum Pop', 'C-Pop', 'Canción', 'Canzone',
            'Chalga', 'Chanson', 'Christian Pop', 'Classical Crossover', 'Country Pop',
            'Dance-Pop', 'Disco Polo', 'Electropop', 'Eurobeat', 'Europop',
            'Fado', 'Folk Pop', 'French Pop', 'Indie Pop', 'Iranian Pop',
            'Italo Dance', 'Italo Disco', 'J-Pop', 'Jangle Pop', 'K-Pop',
            'Latin Ballad', 'Latin Pop', 'Laïkó', 'Louisiana Swamp Pop', 'Mandopop',
            'Mexican Pop', 'Nederpop', 'New Romanticism', 'Operatic Pop', 'Pop Rap',
            'Pop Soul', 'Power Pop', 'Powerpop', 'Progressive Pop', 'Psychedelic Pop',
            'Rebetiko', 'Russian Pop', 'Schlager', 'Soft Rock', 'Sophisti-Pop',
            'Space Age Pop', 'Sunshine Pop', 'Surf Pop', 'Synthpop', 'Teen Pop',
            'Traditional Pop Music', 'Turkish Pop', 'Vispop', 'Wonky Pop', 'Worldbeat',
            /[\s\_\-]pop$/i, /singer[\s\-]songwriter/i,   ]
        },
        {
          value: 'R&B',
          aliases: [
            'Blue-Eyed Soul', 'Boogie', 'Deep Funk', 'Disco', 'Freestyle Music',
            'Freestyle', 'Funk', 'Go-Go', 'Hip Hop Soul', 'Neo Soul',
            'New Jack Swing', 'Northern Soul', 'P-Funk', 'Post-Disco', 'Rnb',
            'Soul', 'Southern Soul', /[\s\_\-]soul/, /r\s?\&\s?b/i, /rhythm (and|n) blues/i,   ]
        },
        {
          value: 'Rock',
          aliases: [
            'Acid Rock', 'Alternative Rock', 'Anarcho Punk', 'Art Punk', 'Art Rock',
            'Beat Music', 'Canterbury Scene', 'Celtic Punk', 'Chinese Rock', 'Christian Punk',
            'Christian Rock', 'Classic Rock', 'Cowpunk', 'Crust Punk', 'D-Beat',
            'Dark Cabaret', 'Deathrock', 'Desert Rock', 'Digital Hardcore', 'Dream Pop',
            'Dunedin Sound', 'Electronic Rock', 'Electronicore', 'Emo', 'Experimental Rock',
            'Folk Punk', 'Folk Rock', 'Freakbeat', 'Garage Punk', 'Garage Rock',
            'Glam Rock', 'Gothic Rock', 'Grunge', 'Gypsy Punk', 'Hard Rock',
            'Hardcore Punk', 'Horror Punk', 'Indie Rock', 'Indie', 'Industrial Rock',
            'Jazz Rock', 'Krautrock', 'Math Rock', 'Nagoya Kei', 'Neo-Psychedelia',
            'Neue Deutsche Härte', 'New Prog', 'New Wave', 'No Wave', 'Noise Rock',
            'Paisley Underground', 'Pop Punk', 'Pop Rock', 'Post-Grunge', 'Post-Punk Revival',
            'Post-Punk', 'Post-Rock', 'Progressive Rock', 'Psychedelic Rock', 'Psychobilly',
            'Punk Rock', 'Raga Rock', 'Rap Rock', 'Riot Grrrl', 'Rock and Roll',
            'Rock in Opposition', 'Sadcore', 'Shoegaze', 'Ska Punk', 'Skate Punk',
            'Slowcore', 'Soft Rock', 'Southern Rock', 'Space Rock', 'Stoner Rock',
            'Street Punk', 'Sufi Rock', 'Surf Rock', 'Visual Kei', 'World Fusion',
            'Worldbeat', /[\s\_\-]rock/i,   ]
        },
        {
          value: 'Religous',
          aliases: [
            'Gospel', 'Gregorian Chant', 'Hymn', 'Reigion',   ]
        },
        {
          value: 'Spoken Word',
          aliases: [
            'Audio Book', 'Audio-Book', 'Spoken',   ]
        }
      ]
    )
  end
end
