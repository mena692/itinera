# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Activity.destroy_all
TripDay.destroy_all
Trip.destroy_all
User.destroy_all

angelo = User.create!(
  email: "angelo@gmail.com",
  password: "Angelo123456!"
)

marvin = User.create!(
  email: "marvin@gmail.com",
  password: "Marvin123456!"
)

tugdual = User.create!(
  email: "tugdual@gmail.com",
  password: "Tugdual123456!"
)

ben = User.create!(
  email: "ben@gmail.com",
  password: "Ben123456!"
)

camila = User.create!(
  email: "camila@gmail.com",
  password: "Camila123456!"
)

andalucia = Trip.create!(
  name: "Trip to Andalucía",
  description: "A nice autumn getaway to the south of Spain",
  destination: "Andalucía",
  group_size: 4,
  vibe: "relaxed",
  user: angelo
)

andalucia_day_one = TripDay.create!(
  name: "Arrival Sevilla",
  description: "First day in Sevilla",
  date: Date.new(2026, 9, 1),
  trip: andalucia
)

andalucia_day_two = TripDay.create!(
  name: "Sevilla walking tour",
  description: "Join a walking tour around town",
  date: Date.new(2026, 9, 2),
  trip: andalucia
)

andalucia_day_three = TripDay.create!(
  name: "Free day",
  description: "We can do whatever we want today",
  date: Date.new(2026, 9, 3),
  trip: andalucia
)

andalucia_day_four = TripDay.create!(
  name: "Sevilla to Granada",
  description: "Check out from Sevilla hotel, travel to Granada",
  date: Date.new(2026, 9, 4),
  trip: andalucia
)

andalucia_day_five = TripDay.create!(
  name: "Granada tour",
  description: "Join a tour of Granada",
  date: Date.new(2026, 9, 5),
  trip: andalucia
)

andalucia_day_six = TripDay.create!(
  name: "Granada to Malaga",
  description: "Check out from Granada hotel, travel to Malaga",
  date: Date.new(2026, 9, 6),
  trip: andalucia
)

andalucia_day_seven = TripDay.create!(
  name: "Beach day",
  description: "Spend the day at the beach and walk around town",
  date: Date.new(2026, 9, 7),
  trip: andalucia
)

andalucia_day_eight = TripDay.create!(
  name: "Departure",
  description: "Leave Malaga and go home",
  date: Date.new(2026, 9, 8),
  trip: andalucia
)

# Day 1 - Arrival Sevilla

Activity.create!(
  name: "Check-in hotel",
  description: "Check in at Hotel NH Sevilla Plaza de Armas",
  start_date: DateTime.new(2026, 9, 1, 14, 00, 0),
  end_date: DateTime.new(2026, 9, 1, 15, 00, 0),
  notes: "Reservation under Angelo Garcia. We should have 2 rooms.",
  category: "accommodation",
  latitude: 37.392436,
  longitude: -6.001853,
  address: "C. Marqués de Paradas, 13, Casco Antiguo, 41001 Sevilla",
  trip_day: andalucia_day_one
)

Activity.create!(
  name: "Stroll through Barrio Santa Cruz",
  description: "Explore Seville's old Jewish quarter, with its narrow whitewashed streets, orange trees, and small plazas",
  start_date: DateTime.new(2026, 9, 1, 17, 0, 0),
  end_date: DateTime.new(2026, 9, 1, 19, 0, 0),
  notes: "Good time to wander before dinner, once the afternoon heat drops off.",
  category: "sightseeing",
  latitude: 37.383933,
  longitude: -5.991039,
  address: "Barrio Santa Cruz, 41004 Sevilla",
  trip_day: andalucia_day_one
)

Activity.create!(
  name: "Dinner at El Rinconcillo",
  description: "Tapas dinner at Seville's oldest bar, founded in 1670",
  start_date: DateTime.new(2026, 9, 1, 21, 0, 0),
  end_date: DateTime.new(2026, 9, 1, 22, 30, 0),
  notes: "Reservation for 2 under Angelo Garcia. Try the espinacas con garbanzos and the salmorejo.",
  category: "food",
  latitude: 37.393981,
  longitude: -5.992332,
  address: "C. Gerona, 40, Casco Antiguo, 41003 Sevilla",
  trip_day: andalucia_day_one
)

# Day 2 - Sevilla walking tour

Activity.create!(
  name: "Walking tour: Cathedral & Casco Antiguo",
  description: "Guided walking tour covering the Cathedral, Giralda, and the old town's key landmarks",
  start_date: DateTime.new(2026, 9, 2, 10, 0, 0),
  end_date: DateTime.new(2026, 9, 2, 13, 0, 0),
  notes: "Meeting point at Plaza Virgen de los Reyes, in front of the Cathedral entrance.",
  category: "sightseeing",
  latitude: 37.385994,
  longitude: -5.992980,
  address: "Plaza Virgen de los Reyes, 41004 Sevilla",
  trip_day: andalucia_day_two
)

Activity.create!(
  name: "Lunch at Bodega Santa Cruz",
  description: "Casual tapas lunch at a popular no-frills bodega near the Cathedral",
  start_date: DateTime.new(2026, 9, 2, 13, 30, 0),
  end_date: DateTime.new(2026, 9, 2, 15, 0, 0),
  notes: "No reservations taken, expect to eat standing at the bar.",
  category: "food",
  latitude: 37.385632,
  longitude: -5.990931,
  address: "C. Rodrigo Caro, 1, Casco Antiguo, 41004 Sevilla",
  trip_day: andalucia_day_two
)

Activity.create!(
  name: "Visit Real Alcázar of Sevilla",
  description: "Explore the royal palace and its gardens, a UNESCO World Heritage Site",
  start_date: DateTime.new(2026, 9, 2, 16, 0, 0),
  end_date: DateTime.new(2026, 9, 2, 18, 0, 0),
  notes: "Buy tickets online in advance to skip the entrance line.",
  category: "sightseeing",
  latitude: 37.383900,
  longitude: -5.990300,
  address: "Patio de Banderas, s/n, 41004 Sevilla",
  trip_day: andalucia_day_two
)

Activity.create!(
  name: "Sunset at Plaza de España",
  description: "Walk around the iconic plaza and Maria Luisa Park as the sun sets",
  start_date: DateTime.new(2026, 9, 2, 19, 30, 0),
  end_date: DateTime.new(2026, 9, 2, 21, 0, 0),
  notes: "Rowboats can be rented on the small canal if there's time.",
  category: "sightseeing",
  latitude: 37.377200,
  longitude: -5.986900,
  address: "Av. de Isabel la Católica, s/n, 41013 Sevilla",
  trip_day: andalucia_day_two
)

# Day 3 - Free day

Activity.create!(
  name: "Visit Museo de Bellas Artes de Sevilla",
  description: "Fine arts museum housed in a former convent, one of Spain's best outside the Prado",
  start_date: DateTime.new(2026, 9, 3, 10, 0, 0),
  end_date: DateTime.new(2026, 9, 3, 12, 0, 0),
  notes: "Free entry for EU citizens, small fee for others.",
  category: "sightseeing",
  latitude: 37.394900,
  longitude: -5.995900,
  address: "Pl. del Museo, 9, 41001 Sevilla",
  trip_day: andalucia_day_three
)

Activity.create!(
  name: "Explore Triana neighborhood",
  description: "Cross the river to wander Triana's ceramic workshops and riverside streets",
  start_date: DateTime.new(2026, 9, 3, 12, 30, 0),
  end_date: DateTime.new(2026, 9, 3, 14, 30, 0),
  notes: "Good spot for ceramics souvenirs along Calle San Jorge.",
  category: "sightseeing",
  latitude: 37.383800,
  longitude: -6.002100,
  address: "Calle San Jacinto, 41010 Sevilla",
  trip_day: andalucia_day_three
)

Activity.create!(
  name: "Dinner at Mercado Lonja del Barranco",
  description: "Food hall by the river with a wide variety of tapas stalls",
  start_date: DateTime.new(2026, 9, 3, 20, 30, 0),
  end_date: DateTime.new(2026, 9, 3, 22, 0, 0),
  notes: "Gets busy on weekday evenings, but tables turn over quickly.",
  category: "food",
  latitude: 37.386800,
  longitude: -6.000900,
  address: "C. Arjona, s/n, 41001 Sevilla",
  trip_day: andalucia_day_three
)

Activity.create!(
  name: "Flamenco show at Casa de la Memoria",
  description: "Intimate live flamenco performance in a historic courtyard venue",
  start_date: DateTime.new(2026, 9, 3, 22, 30, 0),
  end_date: DateTime.new(2026, 9, 3, 23, 30, 0),
  notes: "Reservation for 2 under Angelo Garcia. Arrive 15 minutes early, limited seating.",
  category: "entertainment",
  latitude: 37.385400,
  longitude: -5.989500,
  address: "C. Ximénez de Enciso, 28, 41004 Sevilla",
  trip_day: andalucia_day_three
)

# Day 4 - Sevilla to Granada

Activity.create!(
  name: "Check-out from Hotel NH Sevilla Plaza de Armas",
  description: "Check out and store luggage if needed before heading to the station",
  start_date: DateTime.new(2026, 9, 4, 11, 0, 0),
  end_date: DateTime.new(2026, 9, 4, 11, 30, 0),
  notes: "Reservation under Angelo Garcia.",
  category: "accommodation",
  latitude: 37.392436,
  longitude: -6.001853,
  address: "C. Marqués de Paradas, 13, Casco Antiguo, 41001 Sevilla",
  trip_day: andalucia_day_four
)

Activity.create!(
  name: "Train to Granada",
  description: "High-speed train from Sevilla Santa Justa to Granada",
  start_date: DateTime.new(2026, 9, 4, 12, 15, 0),
  end_date: DateTime.new(2026, 9, 4, 14, 45, 0),
  notes: "Renfe train, journey takes roughly 2.5 hours. Arrive at the station 30 minutes early.",
  category: "transportation",
  latitude: 37.391700,
  longitude: -5.975600,
  address: "Av. Kansas City, s/n, 41018 Sevilla",
  trip_day: andalucia_day_four
)

Activity.create!(
  name: "Check-in at hotel in Granada",
  description: "Check in at Hotel Casa 1800 Granada",
  start_date: DateTime.new(2026, 9, 4, 15, 30, 0),
  end_date: DateTime.new(2026, 9, 4, 16, 0, 0),
  notes: "Reservation under Angelo Garcia. We should have 2 rooms.",
  category: "accommodation",
  latitude: 37.177300,
  longitude: -3.593100,
  address: "C. Benalúa, 11, 18010 Granada",
  trip_day: andalucia_day_four
)

Activity.create!(
  name: "Evening tapas crawl in Granada",
  description: "Wander the streets near Plaza Nueva and Calle Navas trying local tapas bars",
  start_date: DateTime.new(2026, 9, 4, 20, 30, 0),
  end_date: DateTime.new(2026, 9, 4, 22, 30, 0),
  notes: "In Granada tapas usually come free with a drink order.",
  category: "food",
  latitude: 37.176000,
  longitude: -3.596500,
  address: "Plaza Nueva, 18010 Granada",
  trip_day: andalucia_day_four
)

# Day 5 - Granada tour

Activity.create!(
  name: "Guided tour of the Alhambra and Generalife",
  description: "Visit the Nasrid Palaces, Alcazaba fortress, and Generalife gardens",
  start_date: DateTime.new(2026, 9, 5, 9, 0, 0),
  end_date: DateTime.new(2026, 9, 5, 13, 0, 0),
  notes: "Tickets book out weeks in advance — timed entry, don't be late for the Nasrid Palaces slot.",
  category: "sightseeing",
  latitude: 37.176000,
  longitude: -3.588300,
  address: "C. Real de la Alhambra, s/n, 18009 Granada",
  trip_day: andalucia_day_five
)

Activity.create!(
  name: "Lunch in Albaicín",
  description: "Traditional lunch at a restaurant tucked into Granada's old Moorish quarter",
  start_date: DateTime.new(2026, 9, 5, 13, 30, 0),
  end_date: DateTime.new(2026, 9, 5, 15, 0, 0),
  notes: "Try the local specialty, habas con jamón.",
  category: "food",
  latitude: 37.179500,
  longitude: -3.593600,
  address: "Callejón del Aljibe de Trillo, 3, 18010 Granada",
  trip_day: andalucia_day_five
)

Activity.create!(
  name: "Explore Albaicín neighborhood",
  description: "Wander the narrow, winding streets of the old Arab quarter",
  start_date: DateTime.new(2026, 9, 5, 16, 0, 0),
  end_date: DateTime.new(2026, 9, 5, 18, 0, 0),
  notes: "Easy to get lost — that's part of the charm, just head downhill to get back.",
  category: "sightseeing",
  latitude: 37.180500,
  longitude: -3.594800,
  address: "Albaicín, 18010 Granada",
  trip_day: andalucia_day_five
)

Activity.create!(
  name: "Sunset at Mirador de San Nicolás",
  description: "Classic viewpoint looking across at the Alhambra with the Sierra Nevada behind it",
  start_date: DateTime.new(2026, 9, 5, 20, 0, 0),
  end_date: DateTime.new(2026, 9, 5, 21, 0, 0),
  notes: "Gets crowded near sunset — arrive a bit early to get a good spot.",
  category: "sightseeing",
  latitude: 37.180800,
  longitude: -3.594500,
  address: "Plaza Mirador de San Nicolás, 18010 Granada",
  trip_day: andalucia_day_five
)

# Day 6 - Granada to Malaga

Activity.create!(
  name: "Check-out from Granada hotel",
  description: "Check out from Hotel Casa 1800 Granada",
  start_date: DateTime.new(2026, 9, 6, 11, 0, 0),
  end_date: DateTime.new(2026, 9, 6, 11, 30, 0),
  notes: "Reservation under Angelo Garcia.",
  category: "accommodation",
  latitude: 37.177300,
  longitude: -3.593100,
  address: "C. Benalúa, 11, 18010 Granada",
  trip_day: andalucia_day_six
)

Activity.create!(
  name: "Bus to Malaga",
  description: "Direct bus from Granada to Málaga",
  start_date: DateTime.new(2026, 9, 6, 12, 30, 0),
  end_date: DateTime.new(2026, 9, 6, 14, 30, 0),
  notes: "ALSA bus, journey takes roughly 2 hours. Departs from Granada bus station.",
  category: "transportation",
  latitude: 37.182600,
  longitude: -3.610900,
  address: "Av. de Andaluces, s/n, 18014 Granada",
  trip_day: andalucia_day_six
)

Activity.create!(
  name: "Check-in at hotel in Malaga",
  description: "Check in at Hotel Molina Lario",
  start_date: DateTime.new(2026, 9, 6, 15, 0, 0),
  end_date: DateTime.new(2026, 9, 6, 15, 30, 0),
  notes: "Reservation under Angelo Garcia. We should have 2 rooms.",
  category: "accommodation",
  latitude: 36.720500,
  longitude: -4.420000,
  address: "C. Molina Lario, 20, 29015 Málaga",
  trip_day: andalucia_day_six
)

Activity.create!(
  name: "Walk around Malaga historic center",
  description: "Stroll Calle Larios and the streets around the Cathedral",
  start_date: DateTime.new(2026, 9, 6, 17, 0, 0),
  end_date: DateTime.new(2026, 9, 6, 19, 0, 0),
  notes: "Good time to scout dinner spots for the rest of the trip.",
  category: "sightseeing",
  latitude: 36.720200,
  longitude: -4.420300,
  address: "C. Larios, 29005 Málaga",
  trip_day: andalucia_day_six
)

# Day 7 - Beach day

Activity.create!(
  name: "Relax at La Malagueta Beach",
  description: "Morning at Málaga's main city beach",
  start_date: DateTime.new(2026, 9, 7, 10, 0, 0),
  end_date: DateTime.new(2026, 9, 7, 14, 0, 0),
  notes: "Bring sunscreen — very little natural shade on this beach.",
  category: "beach",
  latitude: 36.717500,
  longitude: -4.403800,
  address: "Paseo Marítimo Pablo Ruiz Picasso, 29016 Málaga",
  trip_day: andalucia_day_seven
)

Activity.create!(
  name: "Lunch at a beach chiringuito",
  description: "Fresh grilled seafood at a beachside chiringuito",
  start_date: DateTime.new(2026, 9, 7, 14, 0, 0),
  end_date: DateTime.new(2026, 9, 7, 15, 30, 0),
  notes: "Try the espetos de sardinas, a Málaga specialty.",
  category: "food",
  latitude: 36.718000,
  longitude: -4.404000,
  address: "Paseo Marítimo Pablo Ruiz Picasso, 29016 Málaga",
  trip_day: andalucia_day_seven
)

Activity.create!(
  name: "Visit Alcazaba de Málaga",
  description: "Moorish fortress overlooking the city, with gardens and views of the port",
  start_date: DateTime.new(2026, 9, 7, 17, 0, 0),
  end_date: DateTime.new(2026, 9, 7, 19, 0, 0),
  notes: "Combined ticket with Gibralfaro castle is worth it if there's energy left to climb.",
  category: "sightseeing",
  latitude: 36.721200,
  longitude: -4.415700,
  address: "C. Alcazabilla, 2, 29012 Málaga",
  trip_day: andalucia_day_seven
)

Activity.create!(
  name: "Dinner at El Pimpi",
  description: "Dinner at a historic bodega-style restaurant popular with locals and visitors alike",
  start_date: DateTime.new(2026, 9, 7, 21, 0, 0),
  end_date: DateTime.new(2026, 9, 7, 22, 30, 0),
  notes: "Reservation for 2 under Angelo Garcia. Ask for a table in the courtyard if available.",
  category: "food",
  latitude: 36.721300,
  longitude: -4.418300,
  address: "C. Granada, 62, 29015 Málaga",
  trip_day: andalucia_day_seven
)

# Day 8 - Departure

Activity.create!(
  name: "Breakfast at hotel",
  description: "Final breakfast at Hotel Molina Lario before departure",
  start_date: DateTime.new(2026, 9, 8, 8, 0, 0),
  end_date: DateTime.new(2026, 9, 8, 9, 0, 0),
  notes: "Pack the night before to avoid a rushed morning.",
  category: "food",
  latitude: 36.720500,
  longitude: -4.420000,
  address: "C. Molina Lario, 20, 29015 Málaga",
  trip_day: andalucia_day_eight
)

Activity.create!(
  name: "Check-out from Malaga hotel",
  description: "Check out from Hotel Molina Lario",
  start_date: DateTime.new(2026, 9, 8, 10, 0, 0),
  end_date: DateTime.new(2026, 9, 8, 10, 30, 0),
  notes: "Reservation under Angelo Garcia.",
  category: "accommodation",
  latitude: 36.720500,
  longitude: -4.420000,
  address: "C. Molina Lario, 20, 29015 Málaga",
  trip_day: andalucia_day_eight
)

Activity.create!(
  name: "Transfer to Málaga Airport",
  description: "Taxi or bus transfer to Málaga-Costa del Sol Airport for departure",
  start_date: DateTime.new(2026, 9, 8, 11, 0, 0),
  end_date: DateTime.new(2026, 9, 8, 11, 45, 0),
  notes: "Airport is about 20 minutes from the city center by taxi.",
  category: "transportation",
  latitude: 36.674900,
  longitude: -4.499100,
  address: "Av. Comandante García Morato, s/n, 29004 Málaga",
  trip_day: andalucia_day_eight
)
# ============================================================
# Trip to Japan (marvin)
# ============================================================

japan = Trip.create!(
  name: "Trip to Japan",
  description: "A cultural spring trip through Tokyo and Kyoto",
  destination: "Japan",
  group_size: 1,
  vibe: "cultural",
  user: marvin
)

japan_day_one = TripDay.create!(
  name: "Arrival Tokyo",
  description: "First day in Tokyo",
  date: Date.new(2027, 4, 10),
  trip: japan
)

japan_day_two = TripDay.create!(
  name: "Tokyo highlights",
  description: "Shibuya, Harajuku, and Meiji Shrine",
  date: Date.new(2027, 4, 11),
  trip: japan
)

japan_day_three = TripDay.create!(
  name: "Asakusa & Akihabara",
  description: "Old Tokyo temples and modern pop culture",
  date: Date.new(2027, 4, 12),
  trip: japan
)

japan_day_four = TripDay.create!(
  name: "Tokyo to Kyoto",
  description: "Check out from Tokyo hotel, travel to Kyoto by shinkansen",
  date: Date.new(2027, 4, 13),
  trip: japan
)

japan_day_five = TripDay.create!(
  name: "Kyoto temples tour",
  description: "Fushimi Inari and Kinkaku-ji",
  date: Date.new(2027, 4, 14),
  trip: japan
)

japan_day_six = TripDay.create!(
  name: "Arashiyama free day",
  description: "Bamboo grove and riverside Kyoto",
  date: Date.new(2027, 4, 15),
  trip: japan
)

japan_day_seven = TripDay.create!(
  name: "Departure",
  description: "Leave Kyoto and fly home from Kansai",
  date: Date.new(2027, 4, 16),
  trip: japan
)

# --- Day 1 ---

Activity.create!(
  name: "Check-in at hotel in Shinjuku",
  description: "Check in at Hotel Gracery Shinjuku",
  start_date: DateTime.new(2027, 4, 10, 15, 0, 0),
  end_date: DateTime.new(2027, 4, 10, 15, 30, 0),
  notes: "Reservation under Marvin.",
  category: "accommodation",
  latitude: 35.695200,
  longitude: 139.702800,
  address: "1-19-1 Kabukicho, Shinjuku, Tokyo 160-8466",
  trip_day: japan_day_one
)

Activity.create!(
  name: "Explore Kabukicho & Omoide Yokocho",
  description: "Wander Shinjuku's neon streets and tiny alleyway bars",
  start_date: DateTime.new(2027, 4, 10, 18, 0, 0),
  end_date: DateTime.new(2027, 4, 10, 20, 0, 0),
  notes: "Great for photos once the neon signs light up.",
  category: "sightseeing",
  latitude: 35.694400,
  longitude: 139.700500,
  address: "Omoide Yokocho, Shinjuku, Tokyo 160-0021",
  trip_day: japan_day_one
)

Activity.create!(
  name: "Dinner at an Omoide Yokocho izakaya",
  description: "Yakitori and drinks at a tiny standing-bar izakaya",
  start_date: DateTime.new(2027, 4, 10, 20, 30, 0),
  end_date: DateTime.new(2027, 4, 10, 22, 0, 0),
  notes: "Cash only at most stalls here.",
  category: "food",
  latitude: 35.694300,
  longitude: 139.700300,
  address: "Omoide Yokocho, Shinjuku, Tokyo 160-0021",
  trip_day: japan_day_one
)

# --- Day 2 ---

Activity.create!(
  name: "Visit Meiji Shrine",
  description: "Peaceful forested shrine dedicated to Emperor Meiji",
  start_date: DateTime.new(2027, 4, 11, 9, 0, 0),
  end_date: DateTime.new(2027, 4, 11, 10, 30, 0),
  notes: "Enter through the main torii gate off Omotesando.",
  category: "sightseeing",
  latitude: 35.676400,
  longitude: 139.699300,
  address: "1-1 Yoyogikamizonocho, Shibuya, Tokyo 151-8557",
  trip_day: japan_day_two
)

Activity.create!(
  name: "Explore Harajuku & Takeshita Street",
  description: "Quirky fashion shops and crepe stands",
  start_date: DateTime.new(2027, 4, 11, 11, 0, 0),
  end_date: DateTime.new(2027, 4, 11, 12, 30, 0),
  notes: "Very crowded on weekends.",
  category: "sightseeing",
  latitude: 35.670200,
  longitude: 139.702600,
  address: "Takeshita St, Jingumae, Shibuya, Tokyo 150-0001",
  trip_day: japan_day_two
)

Activity.create!(
  name: "Lunch in Harajuku",
  description: "Casual lunch among Harajuku's side-street cafes",
  start_date: DateTime.new(2027, 4, 11, 12, 30, 0),
  end_date: DateTime.new(2027, 4, 11, 13, 30, 0),
  notes: nil,
  category: "food",
  latitude: 35.670500,
  longitude: 139.702200,
  address: "Jingumae, Shibuya, Tokyo 150-0001",
  trip_day: japan_day_two
)

Activity.create!(
  name: "Shibuya Crossing & Shibuya Sky",
  description: "The world's busiest pedestrian crossing, then views from Shibuya Sky",
  start_date: DateTime.new(2027, 4, 11, 15, 0, 0),
  end_date: DateTime.new(2027, 4, 11, 17, 30, 0),
  notes: "Book Shibuya Sky tickets online in advance for a sunset slot.",
  category: "sightseeing",
  latitude: 35.659500,
  longitude: 139.700400,
  address: "2-24-12 Shibuya, Tokyo 150-0002",
  trip_day: japan_day_two
)

# --- Day 3 ---

Activity.create!(
  name: "Visit Senso-ji Temple",
  description: "Tokyo's oldest temple, with the iconic Kaminarimon gate",
  start_date: DateTime.new(2027, 4, 12, 9, 0, 0),
  end_date: DateTime.new(2027, 4, 12, 11, 0, 0),
  notes: "Nakamise shopping street leads right up to the temple.",
  category: "sightseeing",
  latitude: 35.714800,
  longitude: 139.796700,
  address: "2-3-1 Asakusa, Taito, Tokyo 111-0032",
  trip_day: japan_day_three
)

Activity.create!(
  name: "Tokyo Skytree observation deck",
  description: "Panoramic views over Tokyo from one of the tallest towers in the world",
  start_date: DateTime.new(2027, 4, 12, 11, 30, 0),
  end_date: DateTime.new(2027, 4, 12, 13, 0, 0),
  notes: "A short walk from Senso-ji across the river.",
  category: "sightseeing",
  latitude: 35.710100,
  longitude: 139.810700,
  address: "1-1-2 Oshiage, Sumida, Tokyo 131-0045",
  trip_day: japan_day_three
)

Activity.create!(
  name: "Lunch near Skytree",
  description: "Ramen lunch in the Solamachi complex at the base of the tower",
  start_date: DateTime.new(2027, 4, 12, 13, 0, 0),
  end_date: DateTime.new(2027, 4, 12, 14, 0, 0),
  notes: nil,
  category: "food",
  latitude: 35.709900,
  longitude: 139.810900,
  address: "1-1-2 Oshiage, Sumida, Tokyo 131-0045",
  trip_day: japan_day_three
)

Activity.create!(
  name: "Explore Akihabara",
  description: "Electronics, anime, and retro game shops in Tokyo's otaku district",
  start_date: DateTime.new(2027, 4, 12, 15, 0, 0),
  end_date: DateTime.new(2027, 4, 12, 18, 0, 0),
  notes: "Worth checking a maid cafe or arcade if curious.",
  category: "entertainment",
  latitude: 35.702200,
  longitude: 139.774200,
  address: "Akihabara, Chiyoda, Tokyo 101-0021",
  trip_day: japan_day_three
)

# --- Day 4 ---

Activity.create!(
  name: "Check-out from Shinjuku hotel",
  description: "Check out of Hotel Gracery Shinjuku",
  start_date: DateTime.new(2027, 4, 13, 10, 0, 0),
  end_date: DateTime.new(2027, 4, 13, 10, 30, 0),
  notes: "Reservation under Marvin.",
  category: "accommodation",
  latitude: 35.695200,
  longitude: 139.702800,
  address: "1-19-1 Kabukicho, Shinjuku, Tokyo 160-8466",
  trip_day: japan_day_four
)

Activity.create!(
  name: "Shinkansen to Kyoto",
  description: "Bullet train from Tokyo Station to Kyoto Station",
  start_date: DateTime.new(2027, 4, 13, 11, 0, 0),
  end_date: DateTime.new(2027, 4, 13, 13, 20, 0),
  notes: "Reserved seats on the Tokaido Shinkansen, about 2h20m.",
  category: "transportation",
  latitude: 35.681200,
  longitude: 139.767100,
  address: "1 Chiyoda, Tokyo 100-0005",
  trip_day: japan_day_four
)

Activity.create!(
  name: "Check-in at hotel in Kyoto",
  description: "Check in near Kyoto Station",
  start_date: DateTime.new(2027, 4, 13, 14, 0, 0),
  end_date: DateTime.new(2027, 4, 13, 14, 30, 0),
  notes: "Reservation under Marvin.",
  category: "accommodation",
  latitude: 34.985800,
  longitude: 135.758800,
  address: "Karasuma-dori, Shimogyo, Kyoto 600-8216",
  trip_day: japan_day_four
)

Activity.create!(
  name: "Evening in Gion district",
  description: "Stroll Kyoto's famous geisha district at dusk",
  start_date: DateTime.new(2027, 4, 13, 18, 0, 0),
  end_date: DateTime.new(2027, 4, 13, 20, 0, 0),
  notes: "Be respectful and avoid photographing geiko/maiko without permission.",
  category: "sightseeing",
  latitude: 35.003700,
  longitude: 135.775200,
  address: "Gion, Higashiyama, Kyoto 605-0074",
  trip_day: japan_day_four
)

# --- Day 5 ---

Activity.create!(
  name: "Visit Fushimi Inari Shrine",
  description: "Thousands of vermillion torii gates winding up the mountain",
  start_date: DateTime.new(2027, 4, 14, 8, 30, 0),
  end_date: DateTime.new(2027, 4, 14, 10, 30, 0),
  notes: "Go early to avoid the biggest crowds.",
  category: "sightseeing",
  latitude: 34.967100,
  longitude: 135.772700,
  address: "68 Fukakusa Yabunouchicho, Fushimi, Kyoto 612-0882",
  trip_day: japan_day_five
)

Activity.create!(
  name: "Visit Kinkaku-ji (Golden Pavilion)",
  description: "Zen temple covered in gold leaf, reflected in its pond",
  start_date: DateTime.new(2027, 4, 14, 11, 30, 0),
  end_date: DateTime.new(2027, 4, 14, 13, 0, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 35.039400,
  longitude: 135.729200,
  address: "1 Kinkakujicho, Kita, Kyoto 603-8361",
  trip_day: japan_day_five
)

Activity.create!(
  name: "Lunch near Kinkaku-ji",
  description: "Soba noodle lunch close to the temple grounds",
  start_date: DateTime.new(2027, 4, 14, 13, 0, 0),
  end_date: DateTime.new(2027, 4, 14, 14, 0, 0),
  notes: nil,
  category: "food",
  latitude: 35.038500,
  longitude: 135.730000,
  address: "Kinkakuji-cho, Kita, Kyoto 603-8361",
  trip_day: japan_day_five
)

Activity.create!(
  name: "Nishiki Market food crawl",
  description: "Kyoto's 'kitchen', a narrow covered market full of food stalls",
  start_date: DateTime.new(2027, 4, 14, 17, 0, 0),
  end_date: DateTime.new(2027, 4, 14, 19, 0, 0),
  notes: "Try the tamagoyaki and matcha sweets stalls.",
  category: "food",
  latitude: 35.005100,
  longitude: 135.763800,
  address: "Nishikikoji-dori, Nakagyo, Kyoto 604-8054",
  trip_day: japan_day_five
)

# --- Day 6 ---

Activity.create!(
  name: "Arashiyama Bamboo Grove walk",
  description: "Walk through the famous towering bamboo path",
  start_date: DateTime.new(2027, 4, 15, 9, 0, 0),
  end_date: DateTime.new(2027, 4, 15, 10, 30, 0),
  notes: "Best light in the early morning.",
  category: "sightseeing",
  latitude: 35.009400,
  longitude: 135.668300,
  address: "Sagaogurayama Tabuchiyamacho, Ukyo, Kyoto 616-8394",
  trip_day: japan_day_six
)

Activity.create!(
  name: "Visit Tenryu-ji Temple",
  description: "UNESCO-listed Zen temple with a landscape garden",
  start_date: DateTime.new(2027, 4, 15, 10, 30, 0),
  end_date: DateTime.new(2027, 4, 15, 11, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 35.015600,
  longitude: 135.674100,
  address: "68 Susukinotocho, Ukyo, Kyoto 616-8385",
  trip_day: japan_day_six
)

Activity.create!(
  name: "Lunch in Arashiyama",
  description: "Riverside lunch overlooking the Katsura River",
  start_date: DateTime.new(2027, 4, 15, 12, 0, 0),
  end_date: DateTime.new(2027, 4, 15, 13, 0, 0),
  notes: nil,
  category: "food",
  latitude: 35.011500,
  longitude: 135.677600,
  address: "Saga Tenryuji, Ukyo, Kyoto 616-8385",
  trip_day: japan_day_six
)

Activity.create!(
  name: "Iwatayama Monkey Park",
  description: "Hike up to a park with wild Japanese macaques and city views",
  start_date: DateTime.new(2027, 4, 15, 14, 0, 0),
  end_date: DateTime.new(2027, 4, 15, 15, 30, 0),
  notes: "Steep-ish walk up, wear comfortable shoes.",
  category: "sightseeing",
  latitude: 35.008600,
  longitude: 135.676700,
  address: "8 Arashiyama Genrokuzancho, Nishikyo, Kyoto 616-0004",
  trip_day: japan_day_six
)

# --- Day 7 ---

Activity.create!(
  name: "Check-out from Kyoto hotel",
  description: "Check out near Kyoto Station",
  start_date: DateTime.new(2027, 4, 16, 9, 0, 0),
  end_date: DateTime.new(2027, 4, 16, 9, 30, 0),
  notes: "Reservation under Marvin.",
  category: "accommodation",
  latitude: 34.985800,
  longitude: 135.758800,
  address: "Karasuma-dori, Shimogyo, Kyoto 600-8216",
  trip_day: japan_day_seven
)

Activity.create!(
  name: "Train to Kansai Airport",
  description: "Haruka express train from Kyoto Station to Kansai International Airport",
  start_date: DateTime.new(2027, 4, 16, 10, 0, 0),
  end_date: DateTime.new(2027, 4, 16, 11, 30, 0),
  notes: "Journey takes about 75 minutes.",
  category: "transportation",
  latitude: 34.434700,
  longitude: 135.244100,
  address: "Kansai International Airport, Osaka 549-0011",
  trip_day: japan_day_seven
)

Activity.create!(
  name: "Flight departure from Kansai International Airport",
  description: "Check in and depart for the flight home",
  start_date: DateTime.new(2027, 4, 16, 13, 0, 0),
  end_date: DateTime.new(2027, 4, 16, 14, 0, 0),
  notes: "Arrive at least 3 hours before an international flight.",
  category: "transportation",
  latitude: 34.434700,
  longitude: 135.244100,
  address: "Kansai International Airport, Osaka 549-0011",
  trip_day: japan_day_seven
)

# ============================================================
# Trip to Peru (tugdual)
# ============================================================

peru = Trip.create!(
  name: "Trip to Peru",
  description: "An adventurous trip through Lima, the Sacred Valley, and Machu Picchu",
  destination: "Peru",
  group_size: 3,
  vibe: "adventurous",
  user: tugdual
)

peru_day_one = TripDay.create!(
  name: "Arrival Lima",
  description: "First day in Lima",
  date: Date.new(2027, 6, 5),
  trip: peru
)

peru_day_two = TripDay.create!(
  name: "Lima city tour",
  description: "Historic center and coastal neighborhoods",
  date: Date.new(2027, 6, 6),
  trip: peru
)

peru_day_three = TripDay.create!(
  name: "Lima to Cusco",
  description: "Check out from Lima hotel, fly to Cusco and acclimatize",
  date: Date.new(2027, 6, 7),
  trip: peru
)

peru_day_four = TripDay.create!(
  name: "Sacred Valley",
  description: "Sacsayhuamán, Pisac, and Ollantaytambo",
  date: Date.new(2027, 6, 8),
  trip: peru
)

peru_day_five = TripDay.create!(
  name: "Machu Picchu",
  description: "Full-day trip to Machu Picchu",
  date: Date.new(2027, 6, 9),
  trip: peru
)

peru_day_six = TripDay.create!(
  name: "Cusco free day",
  description: "Markets, temples, and rest",
  date: Date.new(2027, 6, 10),
  trip: peru
)

peru_day_seven = TripDay.create!(
  name: "Departure",
  description: "Leave Cusco and travel home",
  date: Date.new(2027, 6, 11),
  trip: peru
)

# --- Day 1 ---

Activity.create!(
  name: "Check-in at hotel in Miraflores",
  description: "Check in at a hotel in the Miraflores district of Lima",
  start_date: DateTime.new(2027, 6, 5, 15, 0, 0),
  end_date: DateTime.new(2027, 6, 5, 15, 30, 0),
  notes: "Reservation under Tugdual. We should have 2 rooms.",
  category: "accommodation",
  latitude: -12.125800,
  longitude: -77.030800,
  address: "Malecón de la Reserva, Miraflores, Lima 15074",
  trip_day: peru_day_one
)

Activity.create!(
  name: "Walk along the Miraflores Malecón",
  description: "Coastal boardwalk along the cliffs above the Pacific",
  start_date: DateTime.new(2027, 6, 5, 17, 0, 0),
  end_date: DateTime.new(2027, 6, 5, 18, 30, 0),
  notes: "Watch for paragliders launching off the cliffs.",
  category: "sightseeing",
  latitude: -12.121100,
  longitude: -77.029200,
  address: "Malecón de la Reserva, Miraflores, Lima 15074",
  trip_day: peru_day_one
)

Activity.create!(
  name: "Dinner in Barranco",
  description: "Dinner in Lima's bohemian, art-filled district",
  start_date: DateTime.new(2027, 6, 5, 20, 0, 0),
  end_date: DateTime.new(2027, 6, 5, 21, 30, 0),
  notes: "Walk across the Puente de los Suspiros afterward.",
  category: "food",
  latitude: -12.149400,
  longitude: -77.021900,
  address: "Barranco, Lima 15063",
  trip_day: peru_day_one
)

# --- Day 2 ---

Activity.create!(
  name: "Visit Plaza Mayor de Lima & Cathedral",
  description: "Lima's historic main square and colonial cathedral",
  start_date: DateTime.new(2027, 6, 6, 9, 30, 0),
  end_date: DateTime.new(2027, 6, 6, 11, 30, 0),
  notes: "The changing of the guard at the Government Palace happens around noon.",
  category: "sightseeing",
  latitude: -12.046400,
  longitude: -77.030400,
  address: "Plaza Mayor, Lima 15001",
  trip_day: peru_day_two
)

Activity.create!(
  name: "Visit Huaca Pucllana",
  description: "Pre-Incan adobe pyramid in the middle of the city",
  start_date: DateTime.new(2027, 6, 6, 12, 0, 0),
  end_date: DateTime.new(2027, 6, 6, 13, 0, 0),
  notes: "Guided tours run every 30 minutes.",
  category: "sightseeing",
  latitude: -12.108800,
  longitude: -77.029600,
  address: "General Borgoño cuadra 8, Miraflores, Lima 15046",
  trip_day: peru_day_two
)

Activity.create!(
  name: "Ceviche lunch",
  description: "Classic Peruvian ceviche at a Miraflores restaurant",
  start_date: DateTime.new(2027, 6, 6, 13, 0, 0),
  end_date: DateTime.new(2027, 6, 6, 14, 30, 0),
  notes: nil,
  category: "food",
  latitude: -12.120500,
  longitude: -77.030100,
  address: "Miraflores, Lima 15074",
  trip_day: peru_day_two
)

Activity.create!(
  name: "Explore Barranco's murals",
  description: "Street art and galleries in Lima's artsy district",
  start_date: DateTime.new(2027, 6, 6, 16, 0, 0),
  end_date: DateTime.new(2027, 6, 6, 18, 0, 0),
  notes: nil,
  category: "sightseeing",
  latitude: -12.149400,
  longitude: -77.021900,
  address: "Barranco, Lima 15063",
  trip_day: peru_day_two
)

# --- Day 3 ---

Activity.create!(
  name: "Check-out from Lima hotel",
  description: "Check out from the Miraflores hotel",
  start_date: DateTime.new(2027, 6, 7, 8, 0, 0),
  end_date: DateTime.new(2027, 6, 7, 8, 30, 0),
  notes: "Reservation under Tugdual.",
  category: "accommodation",
  latitude: -12.125800,
  longitude: -77.030800,
  address: "Malecón de la Reserva, Miraflores, Lima 15074",
  trip_day: peru_day_three
)

Activity.create!(
  name: "Flight Lima to Cusco",
  description: "Domestic flight from Jorge Chávez to Cusco",
  start_date: DateTime.new(2027, 6, 7, 9, 30, 0),
  end_date: DateTime.new(2027, 6, 7, 11, 0, 0),
  notes: "Flights are frequently delayed by morning fog — build in buffer time.",
  category: "transportation",
  latitude: -12.021900,
  longitude: -77.114300,
  address: "Jorge Chávez International Airport, Callao 07031",
  trip_day: peru_day_three
)

Activity.create!(
  name: "Check-in at hotel in Cusco",
  description: "Check in near Plaza de Armas, Cusco",
  start_date: DateTime.new(2027, 6, 7, 12, 30, 0),
  end_date: DateTime.new(2027, 6, 7, 13, 0, 0),
  notes: "Reservation under Tugdual. We should have 2 rooms.",
  category: "accommodation",
  latitude: -13.517000,
  longitude: -71.978500,
  address: "Plaza de Armas, Cusco 08002",
  trip_day: peru_day_three
)

Activity.create!(
  name: "Easy walk around Plaza de Armas",
  description: "Gentle stroll to acclimatize to the altitude",
  start_date: DateTime.new(2027, 6, 7, 16, 0, 0),
  end_date: DateTime.new(2027, 6, 7, 17, 30, 0),
  notes: "Take it slow — Cusco sits above 3,400m. Drink coca tea if offered.",
  category: "sightseeing",
  latitude: -13.517000,
  longitude: -71.978500,
  address: "Plaza de Armas, Cusco 08002",
  trip_day: peru_day_three
)

# --- Day 4 ---

Activity.create!(
  name: "Visit Sacsayhuamán",
  description: "Massive Incan fortress overlooking Cusco",
  start_date: DateTime.new(2027, 6, 8, 9, 0, 0),
  end_date: DateTime.new(2027, 6, 8, 10, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: -13.507800,
  longitude: -71.982000,
  address: "Sacsayhuamán, Cusco 08003",
  trip_day: peru_day_four
)

Activity.create!(
  name: "Explore Pisac market and ruins",
  description: "Colorful artisan market and Incan terraces in the Sacred Valley",
  start_date: DateTime.new(2027, 6, 8, 11, 30, 0),
  end_date: DateTime.new(2027, 6, 8, 13, 30, 0),
  notes: "Good spot for alpaca wool souvenirs.",
  category: "sightseeing",
  latitude: -13.426000,
  longitude: -71.848000,
  address: "Pisac, Sacred Valley, Cusco 08653",
  trip_day: peru_day_four
)

Activity.create!(
  name: "Lunch in the Sacred Valley",
  description: "Traditional Andean lunch with valley views",
  start_date: DateTime.new(2027, 6, 8, 13, 30, 0),
  end_date: DateTime.new(2027, 6, 8, 14, 30, 0),
  notes: nil,
  category: "food",
  latitude: -13.420000,
  longitude: -71.850000,
  address: "Sacred Valley, Cusco 08653",
  trip_day: peru_day_four
)

Activity.create!(
  name: "Visit Ollantaytambo ruins",
  description: "One of the best-preserved Incan towns, with terraced ruins",
  start_date: DateTime.new(2027, 6, 8, 15, 30, 0),
  end_date: DateTime.new(2027, 6, 8, 17, 30, 0),
  notes: "This is also the departure point for many Machu Picchu trains.",
  category: "sightseeing",
  latitude: -13.259600,
  longitude: -72.263400,
  address: "Ollantaytambo, Sacred Valley, Cusco 08652",
  trip_day: peru_day_four
)

# --- Day 5 ---

Activity.create!(
  name: "Train to Aguas Calientes",
  description: "Scenic train ride along the Urubamba River to the town below Machu Picchu",
  start_date: DateTime.new(2027, 6, 9, 6, 0, 0),
  end_date: DateTime.new(2027, 6, 9, 9, 30, 0),
  notes: "PeruRail or Inca Rail — confirm tickets and boarding station in advance.",
  category: "transportation",
  latitude: -13.155300,
  longitude: -72.525300,
  address: "Aguas Calientes (Machu Picchu Pueblo), Cusco 08681",
  trip_day: peru_day_five
)

Activity.create!(
  name: "Guided tour of Machu Picchu",
  description: "Explore the Incan citadel with a licensed local guide",
  start_date: DateTime.new(2027, 6, 9, 10, 0, 0),
  end_date: DateTime.new(2027, 6, 9, 13, 0, 0),
  notes: "Entry tickets are timed — do not miss the entry slot.",
  category: "sightseeing",
  latitude: -13.163100,
  longitude: -72.545000,
  address: "Machu Picchu, Cusco 08680",
  trip_day: peru_day_five
)

Activity.create!(
  name: "Lunch in Aguas Calientes",
  description: "Lunch back in town before the return train",
  start_date: DateTime.new(2027, 6, 9, 13, 30, 0),
  end_date: DateTime.new(2027, 6, 9, 14, 30, 0),
  notes: nil,
  category: "food",
  latitude: -13.155300,
  longitude: -72.525300,
  address: "Aguas Calientes (Machu Picchu Pueblo), Cusco 08681",
  trip_day: peru_day_five
)

Activity.create!(
  name: "Train back to Cusco",
  description: "Return train journey to Cusco",
  start_date: DateTime.new(2027, 6, 9, 16, 0, 0),
  end_date: DateTime.new(2027, 6, 9, 19, 30, 0),
  notes: nil,
  category: "transportation",
  latitude: -13.517000,
  longitude: -71.978500,
  address: "Cusco 08002",
  trip_day: peru_day_five
)

# --- Day 6 ---

Activity.create!(
  name: "Explore San Pedro Market",
  description: "Cusco's lively local market, full of produce, juices, and local snacks",
  start_date: DateTime.new(2027, 6, 10, 10, 0, 0),
  end_date: DateTime.new(2027, 6, 10, 11, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: -13.521900,
  longitude: -71.978900,
  address: "Mercado San Pedro, Cusco 08002",
  trip_day: peru_day_six
)

Activity.create!(
  name: "Visit Qorikancha Temple",
  description: "Once the most important temple in the Inca Empire, dedicated to the sun",
  start_date: DateTime.new(2027, 6, 10, 12, 0, 0),
  end_date: DateTime.new(2027, 6, 10, 13, 0, 0),
  notes: nil,
  category: "sightseeing",
  latitude: -13.518300,
  longitude: -71.976100,
  address: "Plazoleta Santo Domingo, Cusco 08002",
  trip_day: peru_day_six
)

Activity.create!(
  name: "Free afternoon for shopping and rest",
  description: "Unstructured time to shop for alpaca goods or rest at altitude",
  start_date: DateTime.new(2027, 6, 10, 15, 0, 0),
  end_date: DateTime.new(2027, 6, 10, 17, 0, 0),
  notes: nil,
  category: "leisure",
  latitude: -13.517000,
  longitude: -71.978500,
  address: "Plaza de Armas, Cusco 08002",
  trip_day: peru_day_six
)

Activity.create!(
  name: "Farewell dinner in Cusco",
  description: "Final group dinner featuring local specialties",
  start_date: DateTime.new(2027, 6, 10, 20, 0, 0),
  end_date: DateTime.new(2027, 6, 10, 21, 30, 0),
  notes: "Reservation for 3 under Tugdual.",
  category: "food",
  latitude: -13.517500,
  longitude: -71.978200,
  address: "Plaza de Armas, Cusco 08002",
  trip_day: peru_day_six
)

# --- Day 7 ---

Activity.create!(
  name: "Check-out from Cusco hotel",
  description: "Check out near Plaza de Armas",
  start_date: DateTime.new(2027, 6, 11, 9, 0, 0),
  end_date: DateTime.new(2027, 6, 11, 9, 30, 0),
  notes: "Reservation under Tugdual.",
  category: "accommodation",
  latitude: -13.517000,
  longitude: -71.978500,
  address: "Plaza de Armas, Cusco 08002",
  trip_day: peru_day_seven
)

Activity.create!(
  name: "Transfer to Cusco airport",
  description: "Taxi transfer to Alejandro Velasco Astete Airport",
  start_date: DateTime.new(2027, 6, 11, 10, 0, 0),
  end_date: DateTime.new(2027, 6, 11, 10, 30, 0),
  notes: nil,
  category: "transportation",
  latitude: -13.535700,
  longitude: -71.938800,
  address: "Alejandro Velasco Astete International Airport, Cusco 08000",
  trip_day: peru_day_seven
)

Activity.create!(
  name: "Flight home via Lima",
  description: "Connecting flight from Cusco through Lima for the journey home",
  start_date: DateTime.new(2027, 6, 11, 11, 0, 0),
  end_date: DateTime.new(2027, 6, 11, 12, 30, 0),
  notes: nil,
  category: "transportation",
  latitude: -13.535700,
  longitude: -71.938800,
  address: "Alejandro Velasco Astete International Airport, Cusco 08000",
  trip_day: peru_day_seven
)

# ============================================================
# Trip to Hawaii (ben)
# ============================================================

hawaii = Trip.create!(
  name: "Trip to Hawaii",
  description: "A relaxed week on Oahu, mixing beaches with a bit of hiking and history",
  destination: "Hawaii",
  group_size: 2,
  vibe: "relaxed",
  user: ben
)

hawaii_day_one = TripDay.create!(
  name: "Arrival Honolulu",
  description: "First day in Honolulu",
  date: Date.new(2027, 7, 3),
  trip: hawaii
)

hawaii_day_two = TripDay.create!(
  name: "Waikiki & Diamond Head",
  description: "Sunrise hike and beach time",
  date: Date.new(2027, 7, 4),
  trip: hawaii
)

hawaii_day_three = TripDay.create!(
  name: "North Shore day trip",
  description: "Big-wave beaches and Haleiwa town",
  date: Date.new(2027, 7, 5),
  trip: hawaii
)

hawaii_day_four = TripDay.create!(
  name: "Pearl Harbor & history",
  description: "USS Arizona Memorial and Iolani Palace",
  date: Date.new(2027, 7, 6),
  trip: hawaii
)

hawaii_day_five = TripDay.create!(
  name: "Beach day at Lanikai/Kailua",
  description: "Kayaking and relaxing on the Windward side",
  date: Date.new(2027, 7, 7),
  trip: hawaii
)

hawaii_day_six = TripDay.create!(
  name: "Hike & waterfalls",
  description: "Manoa Falls hike and botanical gardens",
  date: Date.new(2027, 7, 8),
  trip: hawaii
)

hawaii_day_seven = TripDay.create!(
  name: "Departure",
  description: "Leave Honolulu and travel home",
  date: Date.new(2027, 7, 9),
  trip: hawaii
)

# --- Day 1 ---

Activity.create!(
  name: "Check-in at hotel in Waikiki",
  description: "Check in near Waikiki Beach",
  start_date: DateTime.new(2027, 7, 3, 15, 0, 0),
  end_date: DateTime.new(2027, 7, 3, 15, 30, 0),
  notes: "Reservation under Ben. We should have 2 rooms.",
  category: "accommodation",
  latitude: 21.279300,
  longitude: -157.829300,
  address: "Kalakaua Ave, Waikiki, Honolulu, HI 96815",
  trip_day: hawaii_day_one
)

Activity.create!(
  name: "Sunset walk on Waikiki Beach",
  description: "Easy first-evening stroll along the beach",
  start_date: DateTime.new(2027, 7, 3, 18, 0, 0),
  end_date: DateTime.new(2027, 7, 3, 19, 30, 0),
  notes: nil,
  category: "beach",
  latitude: 21.276000,
  longitude: -157.827000,
  address: "Waikiki Beach, Honolulu, HI 96815",
  trip_day: hawaii_day_one
)

Activity.create!(
  name: "Dinner at a beachfront restaurant",
  description: "First-night dinner with ocean views",
  start_date: DateTime.new(2027, 7, 3, 20, 0, 0),
  end_date: DateTime.new(2027, 7, 3, 21, 30, 0),
  notes: "Reservation for 2 under Ben.",
  category: "food",
  latitude: 21.276500,
  longitude: -157.826800,
  address: "Kalakaua Ave, Waikiki, Honolulu, HI 96815",
  trip_day: hawaii_day_one
)

# --- Day 2 ---

Activity.create!(
  name: "Hike Diamond Head State Monument",
  description: "Short but steep hike to a crater rim overlooking Waikiki",
  start_date: DateTime.new(2027, 7, 4, 7, 0, 0),
  end_date: DateTime.new(2027, 7, 4, 9, 30, 0),
  notes: "Reservations required in advance for the parking/entry slot. Bring water.",
  category: "hiking",
  latitude: 21.262000,
  longitude: -157.805600,
  address: "Diamond Head Rd, Honolulu, HI 96815",
  trip_day: hawaii_day_two
)

Activity.create!(
  name: "Relax at Waikiki Beach",
  description: "Swimming and sunbathing back at the main beach",
  start_date: DateTime.new(2027, 7, 4, 10, 30, 0),
  end_date: DateTime.new(2027, 7, 4, 13, 0, 0),
  notes: nil,
  category: "beach",
  latitude: 21.279300,
  longitude: -157.829300,
  address: "Waikiki Beach, Honolulu, HI 96815",
  trip_day: hawaii_day_two
)

Activity.create!(
  name: "Lunch at a poke bowl spot",
  description: "Casual lunch of fresh poke",
  start_date: DateTime.new(2027, 7, 4, 13, 0, 0),
  end_date: DateTime.new(2027, 7, 4, 14, 0, 0),
  notes: nil,
  category: "food",
  latitude: 21.280000,
  longitude: -157.831000,
  address: "Waikiki, Honolulu, HI 96815",
  trip_day: hawaii_day_two
)

Activity.create!(
  name: "Explore International Market Place",
  description: "Open-air shopping and dining complex in the heart of Waikiki",
  start_date: DateTime.new(2027, 7, 4, 16, 0, 0),
  end_date: DateTime.new(2027, 7, 4, 17, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 21.281800,
  longitude: -157.831900,
  address: "2330 Kalakaua Ave, Honolulu, HI 96815",
  trip_day: hawaii_day_two
)

# --- Day 3 ---

Activity.create!(
  name: "Waimea Bay",
  description: "Stop at one of the North Shore's most famous beaches",
  start_date: DateTime.new(2027, 7, 5, 9, 0, 0),
  end_date: DateTime.new(2027, 7, 5, 11, 0, 0),
  notes: "Calm in summer, but always check ocean safety flags.",
  category: "beach",
  latitude: 21.641700,
  longitude: -158.065600,
  address: "Waimea Bay Beach Park, Haleiwa, HI 96712",
  trip_day: hawaii_day_three
)

Activity.create!(
  name: "Sunset Beach",
  description: "Watch surfers tackle the North Shore's famous winter swells (or just relax in summer)",
  start_date: DateTime.new(2027, 7, 5, 11, 30, 0),
  end_date: DateTime.new(2027, 7, 5, 13, 0, 0),
  notes: nil,
  category: "beach",
  latitude: 21.679500,
  longitude: -158.040300,
  address: "Sunset Beach, Haleiwa, HI 96712",
  trip_day: hawaii_day_three
)

Activity.create!(
  name: "Shrimp truck lunch in Haleiwa",
  description: "Garlic shrimp plate lunch from a North Shore food truck",
  start_date: DateTime.new(2027, 7, 5, 13, 30, 0),
  end_date: DateTime.new(2027, 7, 5, 14, 30, 0),
  notes: nil,
  category: "food",
  latitude: 21.590600,
  longitude: -158.104600,
  address: "Kamehameha Hwy, Haleiwa, HI 96712",
  trip_day: hawaii_day_three
)

Activity.create!(
  name: "Explore Haleiwa town",
  description: "Surf shops, boutiques, and shave ice in the North Shore's main town",
  start_date: DateTime.new(2027, 7, 5, 15, 0, 0),
  end_date: DateTime.new(2027, 7, 5, 16, 30, 0),
  notes: "Don't skip the shave ice.",
  category: "sightseeing",
  latitude: 21.590600,
  longitude: -158.104600,
  address: "Haleiwa, HI 96712",
  trip_day: hawaii_day_three
)

# --- Day 4 ---

Activity.create!(
  name: "Pearl Harbor & USS Arizona Memorial",
  description: "Visit the memorial and museum honoring the December 7, 1941 attack",
  start_date: DateTime.new(2027, 7, 6, 8, 0, 0),
  end_date: DateTime.new(2027, 7, 6, 11, 0, 0),
  notes: "Book the boat shuttle to the memorial well in advance — it sells out.",
  category: "sightseeing",
  latitude: 21.364900,
  longitude: -157.950600,
  address: "1 Arizona Memorial Pl, Honolulu, HI 96818",
  trip_day: hawaii_day_four
)

Activity.create!(
  name: "Lunch near Pearl Harbor",
  description: "Casual lunch close to the visitor center",
  start_date: DateTime.new(2027, 7, 6, 11, 30, 0),
  end_date: DateTime.new(2027, 7, 6, 12, 30, 0),
  notes: nil,
  category: "food",
  latitude: 21.363000,
  longitude: -157.955000,
  address: "Honolulu, HI 96818",
  trip_day: hawaii_day_four
)

Activity.create!(
  name: "Visit Iolani Palace",
  description: "The only royal palace on US soil, former home of the Hawaiian monarchy",
  start_date: DateTime.new(2027, 7, 6, 14, 0, 0),
  end_date: DateTime.new(2027, 7, 6, 15, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 21.306900,
  longitude: -157.858300,
  address: "364 S King St, Honolulu, HI 96813",
  trip_day: hawaii_day_four
)

Activity.create!(
  name: "Relax at the hotel pool",
  description: "Downtime back at the hotel after a history-heavy day",
  start_date: DateTime.new(2027, 7, 6, 17, 0, 0),
  end_date: DateTime.new(2027, 7, 6, 18, 30, 0),
  notes: nil,
  category: "leisure",
  latitude: 21.279300,
  longitude: -157.829300,
  address: "Kalakaua Ave, Waikiki, Honolulu, HI 96815",
  trip_day: hawaii_day_four
)

# --- Day 5 ---

Activity.create!(
  name: "Kayaking at Lanikai Beach",
  description: "Turquoise water and a paddle out toward the Mokulua islets",
  start_date: DateTime.new(2027, 7, 7, 9, 0, 0),
  end_date: DateTime.new(2027, 7, 7, 12, 0, 0),
  notes: "No public parking lot — arrive early and park on a nearby street.",
  category: "beach",
  latitude: 21.393100,
  longitude: -157.714700,
  address: "Lanikai Beach, Kailua, HI 96734",
  trip_day: hawaii_day_five
)

Activity.create!(
  name: "Lunch in Kailua town",
  description: "Lunch at one of Kailua's casual local spots",
  start_date: DateTime.new(2027, 7, 7, 12, 30, 0),
  end_date: DateTime.new(2027, 7, 7, 13, 30, 0),
  notes: nil,
  category: "food",
  latitude: 21.397800,
  longitude: -157.739600,
  address: "Kailua, HI 96734",
  trip_day: hawaii_day_five
)

Activity.create!(
  name: "Swim at Kailua Beach Park",
  description: "Wide, calm beach popular with local families",
  start_date: DateTime.new(2027, 7, 7, 14, 0, 0),
  end_date: DateTime.new(2027, 7, 7, 16, 30, 0),
  notes: nil,
  category: "beach",
  latitude: 21.395800,
  longitude: -157.735000,
  address: "Kailua Beach Park, Kailua, HI 96734",
  trip_day: hawaii_day_five
)

# --- Day 6 ---

Activity.create!(
  name: "Hike to Manoa Falls",
  description: "Short rainforest hike to a 150-foot waterfall",
  start_date: DateTime.new(2027, 7, 8, 8, 0, 0),
  end_date: DateTime.new(2027, 7, 8, 10, 30, 0),
  notes: "Can be muddy — wear proper shoes.",
  category: "hiking",
  latitude: 21.332900,
  longitude: -157.800600,
  address: "Manoa Falls Trail, Honolulu, HI 96822",
  trip_day: hawaii_day_six
)

Activity.create!(
  name: "Lunch in Manoa Valley",
  description: "Casual lunch near the trailhead",
  start_date: DateTime.new(2027, 7, 8, 11, 0, 0),
  end_date: DateTime.new(2027, 7, 8, 12, 0, 0),
  notes: nil,
  category: "food",
  latitude: 21.313000,
  longitude: -157.816000,
  address: "Manoa, Honolulu, HI 96822",
  trip_day: hawaii_day_six
)

Activity.create!(
  name: "Visit Foster Botanical Garden",
  description: "Tropical botanical garden with centuries-old trees",
  start_date: DateTime.new(2027, 7, 8, 13, 0, 0),
  end_date: DateTime.new(2027, 7, 8, 14, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 21.315700,
  longitude: -157.860800,
  address: "180 N Vineyard Blvd, Honolulu, HI 96817",
  trip_day: hawaii_day_six
)

Activity.create!(
  name: "Farewell dinner in Waikiki",
  description: "Final dinner together before departure",
  start_date: DateTime.new(2027, 7, 8, 19, 0, 0),
  end_date: DateTime.new(2027, 7, 8, 20, 30, 0),
  notes: "Reservation for 2 under Ben.",
  category: "food",
  latitude: 21.278000,
  longitude: -157.828000,
  address: "Kalakaua Ave, Waikiki, Honolulu, HI 96815",
  trip_day: hawaii_day_six
)

# --- Day 7 ---

Activity.create!(
  name: "Check-out from Waikiki hotel",
  description: "Check out of the Waikiki hotel",
  start_date: DateTime.new(2027, 7, 9, 10, 0, 0),
  end_date: DateTime.new(2027, 7, 9, 10, 30, 0),
  notes: "Reservation under Ben.",
  category: "accommodation",
  latitude: 21.279300,
  longitude: -157.829300,
  address: "Kalakaua Ave, Waikiki, Honolulu, HI 96815",
  trip_day: hawaii_day_seven
)

Activity.create!(
  name: "Transfer to Honolulu Airport",
  description: "Taxi or shuttle transfer to Daniel K. Inouye International Airport",
  start_date: DateTime.new(2027, 7, 9, 11, 0, 0),
  end_date: DateTime.new(2027, 7, 9, 11, 45, 0),
  notes: nil,
  category: "transportation",
  latitude: 21.324500,
  longitude: -157.925100,
  address: "Daniel K. Inouye International Airport, Honolulu, HI 96819",
  trip_day: hawaii_day_seven
)

# ============================================================
# Trip to Catalunya (camila)
# ============================================================

catalunya = Trip.create!(
  name: "Trip to Catalunya",
  description: "A cultural family trip through Barcelona and day trips around Catalunya",
  destination: "Catalunya",
  group_size: 4,
  vibe: "cultural",
  user: camila
)

catalunya_day_one = TripDay.create!(
  name: "Arrival Barcelona",
  description: "First day in Barcelona",
  date: Date.new(2027, 9, 10),
  trip: catalunya
)

catalunya_day_two = TripDay.create!(
  name: "Gothic Quarter & Sagrada Família",
  description: "Historic center and Gaudí's masterpiece",
  date: Date.new(2027, 9, 11),
  trip: catalunya
)

catalunya_day_three = TripDay.create!(
  name: "Gaudí trail",
  description: "Park Güell, Casa Batlló, and Casa Milà",
  date: Date.new(2027, 9, 12),
  trip: catalunya
)

catalunya_day_four = TripDay.create!(
  name: "Beach day",
  description: "Barceloneta beach and the port",
  date: Date.new(2027, 9, 13),
  trip: catalunya
)

catalunya_day_five = TripDay.create!(
  name: "Day trip to Girona",
  description: "Medieval old town and cathedral",
  date: Date.new(2027, 9, 14),
  trip: catalunya
)

catalunya_day_six = TripDay.create!(
  name: "Montserrat day trip",
  description: "Mountain monastery and hiking",
  date: Date.new(2027, 9, 15),
  trip: catalunya
)

catalunya_day_seven = TripDay.create!(
  name: "Departure",
  description: "Leave Barcelona and travel home",
  date: Date.new(2027, 9, 16),
  trip: catalunya
)

# --- Day 1 ---

Activity.create!(
  name: "Check-in at hotel in Barcelona",
  description: "Check in near the Gothic Quarter",
  start_date: DateTime.new(2027, 9, 10, 15, 0, 0),
  end_date: DateTime.new(2027, 9, 10, 15, 30, 0),
  notes: "Reservation under Camila. We should have 2 rooms.",
  category: "accommodation",
  latitude: 41.383900,
  longitude: 2.176500,
  address: "Av. de la Catedral, 7, Ciutat Vella, 08002 Barcelona",
  trip_day: catalunya_day_one
)

Activity.create!(
  name: "Walk through Barri Gòtic",
  description: "Wander the medieval streets of the Gothic Quarter",
  start_date: DateTime.new(2027, 9, 10, 17, 0, 0),
  end_date: DateTime.new(2027, 9, 10, 19, 0, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 41.383300,
  longitude: 2.176100,
  address: "Barri Gòtic, 08002 Barcelona",
  trip_day: catalunya_day_one
)

Activity.create!(
  name: "Tapas dinner near La Rambla",
  description: "First-night tapas dinner in the city center",
  start_date: DateTime.new(2027, 9, 10, 21, 0, 0),
  end_date: DateTime.new(2027, 9, 10, 22, 30, 0),
  notes: "Reservation for 4 under Camila.",
  category: "food",
  latitude: 41.380900,
  longitude: 2.173100,
  address: "La Rambla, 08002 Barcelona",
  trip_day: catalunya_day_one
)

# --- Day 2 ---

Activity.create!(
  name: "Visit Barcelona Cathedral",
  description: "Gothic cathedral in the heart of the old town",
  start_date: DateTime.new(2027, 9, 11, 9, 30, 0),
  end_date: DateTime.new(2027, 9, 11, 11, 0, 0),
  notes: "Rooftop access has separate opening hours.",
  category: "sightseeing",
  latitude: 41.383900,
  longitude: 2.176500,
  address: "Pla de la Seu, s/n, 08002 Barcelona",
  trip_day: catalunya_day_two
)

Activity.create!(
  name: "Visit Sagrada Família",
  description: "Gaudí's unfinished masterpiece basilica",
  start_date: DateTime.new(2027, 9, 11, 12, 0, 0),
  end_date: DateTime.new(2027, 9, 11, 14, 0, 0),
  notes: "Book timed tickets online well in advance.",
  category: "sightseeing",
  latitude: 41.403600,
  longitude: 2.174400,
  address: "C. de Mallorca, 401, 08013 Barcelona",
  trip_day: catalunya_day_two
)

Activity.create!(
  name: "Lunch near Sagrada Família",
  description: "Casual lunch close to the basilica",
  start_date: DateTime.new(2027, 9, 11, 14, 0, 0),
  end_date: DateTime.new(2027, 9, 11, 15, 0, 0),
  notes: nil,
  category: "food",
  latitude: 41.403200,
  longitude: 2.173900,
  address: "Eixample, 08013 Barcelona",
  trip_day: catalunya_day_two
)

Activity.create!(
  name: "Explore El Born",
  description: "Trendy neighborhood of narrow streets, boutiques, and the Santa Maria del Mar basilica",
  start_date: DateTime.new(2027, 9, 11, 17, 0, 0),
  end_date: DateTime.new(2027, 9, 11, 19, 0, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 41.385000,
  longitude: 2.182700,
  address: "El Born, 08003 Barcelona",
  trip_day: catalunya_day_two
)

# --- Day 3 ---

Activity.create!(
  name: "Visit Park Güell",
  description: "Whimsical Gaudí-designed park with mosaic terraces and city views",
  start_date: DateTime.new(2027, 9, 12, 9, 0, 0),
  end_date: DateTime.new(2027, 9, 12, 11, 0, 0),
  notes: "Timed entry tickets required for the monumental zone.",
  category: "sightseeing",
  latitude: 41.414500,
  longitude: 2.152700,
  address: "08024 Barcelona",
  trip_day: catalunya_day_three
)

Activity.create!(
  name: "Visit Casa Batlló",
  description: "One of Gaudí's most famous facades, inspired by natural forms",
  start_date: DateTime.new(2027, 9, 12, 12, 0, 0),
  end_date: DateTime.new(2027, 9, 12, 13, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 41.391600,
  longitude: 2.164900,
  address: "Pg. de Gràcia, 43, 08007 Barcelona",
  trip_day: catalunya_day_three
)

Activity.create!(
  name: "Lunch on Passeig de Gràcia",
  description: "Lunch along Barcelona's grand boulevard",
  start_date: DateTime.new(2027, 9, 12, 13, 30, 0),
  end_date: DateTime.new(2027, 9, 12, 14, 30, 0),
  notes: nil,
  category: "food",
  latitude: 41.393000,
  longitude: 2.164700,
  address: "Pg. de Gràcia, 08008 Barcelona",
  trip_day: catalunya_day_three
)

Activity.create!(
  name: "Visit Casa Milà (La Pedrera)",
  description: "Gaudí's undulating stone apartment building, with a rooftop of surreal chimneys",
  start_date: DateTime.new(2027, 9, 12, 15, 30, 0),
  end_date: DateTime.new(2027, 9, 12, 17, 0, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 41.395300,
  longitude: 2.161900,
  address: "Pg. de Gràcia, 92, 08008 Barcelona",
  trip_day: catalunya_day_three
)

# --- Day 4 ---

Activity.create!(
  name: "Relax at Barceloneta Beach",
  description: "Morning at Barcelona's main city beach",
  start_date: DateTime.new(2027, 9, 13, 10, 0, 0),
  end_date: DateTime.new(2027, 9, 13, 13, 0, 0),
  notes: nil,
  category: "beach",
  latitude: 41.378400,
  longitude: 2.192500,
  address: "Platja de la Barceloneta, 08003 Barcelona",
  trip_day: catalunya_day_four
)

Activity.create!(
  name: "Seafood lunch in Barceloneta",
  description: "Fresh seafood lunch in the old fishermen's quarter",
  start_date: DateTime.new(2027, 9, 13, 13, 30, 0),
  end_date: DateTime.new(2027, 9, 13, 15, 0, 0),
  notes: "Reservation for 4 under Camila.",
  category: "food",
  latitude: 41.376800,
  longitude: 2.189700,
  address: "Barceloneta, 08003 Barcelona",
  trip_day: catalunya_day_four
)

Activity.create!(
  name: "Visit Port Vell & Maremagnum",
  description: "Marina walk and waterfront shopping complex",
  start_date: DateTime.new(2027, 9, 13, 16, 0, 0),
  end_date: DateTime.new(2027, 9, 13, 17, 30, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 41.376800,
  longitude: 2.183700,
  address: "Moll d'Espanya, 08039 Barcelona",
  trip_day: catalunya_day_four
)

Activity.create!(
  name: "Sunset drinks at a beach bar",
  description: "Relaxed evening at a beachfront chiringuito",
  start_date: DateTime.new(2027, 9, 13, 19, 0, 0),
  end_date: DateTime.new(2027, 9, 13, 20, 30, 0),
  notes: nil,
  category: "leisure",
  latitude: 41.379000,
  longitude: 2.191500,
  address: "Platja de la Barceloneta, 08003 Barcelona",
  trip_day: catalunya_day_four
)

# --- Day 5 ---

Activity.create!(
  name: "Train to Girona",
  description: "High-speed train from Barcelona Sants to Girona",
  start_date: DateTime.new(2027, 9, 14, 8, 30, 0),
  end_date: DateTime.new(2027, 9, 14, 9, 30, 0),
  notes: "Journey takes under 40 minutes on the fastest trains.",
  category: "transportation",
  latitude: 41.379200,
  longitude: 2.140400,
  address: "Pl. dels Països Catalans, s/n, 08014 Barcelona",
  trip_day: catalunya_day_five
)

Activity.create!(
  name: "Explore Girona's old town & cathedral",
  description: "Medieval streets, the Jewish quarter, and the imposing cathedral steps",
  start_date: DateTime.new(2027, 9, 14, 10, 0, 0),
  end_date: DateTime.new(2027, 9, 14, 12, 30, 0),
  notes: "Fans of Game of Thrones will recognize the cathedral steps.",
  category: "sightseeing",
  latitude: 41.986500,
  longitude: 2.824700,
  address: "Pl. de la Catedral, 17004 Girona",
  trip_day: catalunya_day_five
)

Activity.create!(
  name: "Lunch in Girona",
  description: "Lunch in the old town near the river",
  start_date: DateTime.new(2027, 9, 14, 12, 30, 0),
  end_date: DateTime.new(2027, 9, 14, 13, 30, 0),
  notes: nil,
  category: "food",
  latitude: 41.983100,
  longitude: 2.824900,
  address: "Barri Vell, 17004 Girona",
  trip_day: catalunya_day_five
)

Activity.create!(
  name: "Train back to Barcelona",
  description: "Return train journey to Barcelona",
  start_date: DateTime.new(2027, 9, 14, 17, 0, 0),
  end_date: DateTime.new(2027, 9, 14, 18, 0, 0),
  notes: nil,
  category: "transportation",
  latitude: 41.986500,
  longitude: 2.824700,
  address: "Girona 17004",
  trip_day: catalunya_day_five
)

# --- Day 6 ---

Activity.create!(
  name: "Cable car to Montserrat",
  description: "Aeri de Montserrat cable car up to the mountain monastery",
  start_date: DateTime.new(2027, 9, 15, 8, 30, 0),
  end_date: DateTime.new(2027, 9, 15, 10, 0, 0),
  notes: "Combined rail + cable car tickets can be bought at Barcelona Espanya station.",
  category: "transportation",
  latitude: 41.593800,
  longitude: 1.838300,
  address: "Montserrat, 08199 Barcelona",
  trip_day: catalunya_day_six
)

Activity.create!(
  name: "Visit Montserrat Monastery & Basilica",
  description: "Benedictine monastery famous for the Black Madonna statue",
  start_date: DateTime.new(2027, 9, 15, 10, 0, 0),
  end_date: DateTime.new(2027, 9, 15, 12, 0, 0),
  notes: nil,
  category: "sightseeing",
  latitude: 41.593800,
  longitude: 1.838300,
  address: "Montserrat, 08199 Barcelona",
  trip_day: catalunya_day_six
)

Activity.create!(
  name: "Hike to Sant Jeroni viewpoint",
  description: "Trail to the highest point of the Montserrat massif, with sweeping views",
  start_date: DateTime.new(2027, 9, 15, 12, 30, 0),
  end_date: DateTime.new(2027, 9, 15, 15, 0, 0),
  notes: "A funicular covers part of the ascent if legs are tired.",
  category: "hiking",
  latitude: 41.601900,
  longitude: 1.812900,
  address: "Sant Jeroni, Montserrat, 08199 Barcelona",
  trip_day: catalunya_day_six
)

Activity.create!(
  name: "Farewell dinner in Barcelona",
  description: "Final group dinner back in the city",
  start_date: DateTime.new(2027, 9, 15, 20, 0, 0),
  end_date: DateTime.new(2027, 9, 15, 21, 30, 0),
  notes: "Reservation for 4 under Camila.",
  category: "food",
  latitude: 41.386000,
  longitude: 2.170000,
  address: "Eixample, 08008 Barcelona",
  trip_day: catalunya_day_six
)

# --- Day 7 ---

Activity.create!(
  name: "Check-out from Barcelona hotel",
  description: "Check out near the Gothic Quarter",
  start_date: DateTime.new(2027, 9, 16, 10, 0, 0),
  end_date: DateTime.new(2027, 9, 16, 10, 30, 0),
  notes: "Reservation under Camila.",
  category: "accommodation",
  latitude: 41.383900,
  longitude: 2.176500,
  address: "Av. de la Catedral, 7, Ciutat Vella, 08002 Barcelona",
  trip_day: catalunya_day_seven
)

Activity.create!(
  name: "Transfer to Barcelona Airport",
  description: "Taxi or Aerobús transfer to Barcelona-El Prat Airport",
  start_date: DateTime.new(2027, 9, 16, 11, 0, 0),
  end_date: DateTime.new(2027, 9, 16, 11, 45, 0),
  notes: nil,
  category: "transportation",
  latitude: 41.297100,
  longitude: 2.078500,
  address: "Barcelona-El Prat Airport, 08820 El Prat de Llobregat",
  trip_day: catalunya_day_seven
)
