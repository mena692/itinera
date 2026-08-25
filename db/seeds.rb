# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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

andalucia_day_one = TripDays.create!(
  name: "Arrival Sevilla",
  description: "First day in Sevilla",
  date: Date.new(2026, 9, 1),
  trip: andalucia
)

andalucia_day_two = TripDays.create!(
  name: "Sevilla walking tour",
  description: "Join a walking tour around town",
  date: Date.new(2026, 9, 2),
  trip: andalucia
)

andalucia_day_three = TripDays.create!(
  name: "Free day",
  description: "We can do whatever we want today",
  date: Date.new(2026, 9, 3),
  trip: andalucia
)

andalucia_day_four = TripDays.create!(
  name: "Sevilla to Granada",
  description: "Check out from Sevilla hotel, travel to Granada",
  date: Date.new(2026, 9, 4),
  trip: andalucia
)

andalucia_day_five = TripDays.create!(
  name: "Granada tour",
  description: "Join a tour of Granada",
  date: Date.new(2026, 9, 5),
  trip: andalucia
)

andalucia_day_six = TripDays.create!(
  name: "Granada to Malaga",
  description: "Check out from Granada hotel, travel to Malaga",
  date: Date.new(2026, 9, 6),
  trip: andalucia
)

andalucia_day_seven = TripDays.create!(
  name: "Beach day",
  description: "Spend the day at the beach and walk around town",
  date: Date.new(2026, 9, 7),
  trip: andalucia
)

andalucia_day_eight = TripDays.create!(
  name: "Departure",
  description: "Leave Malaga and go home",
  date: Date.new(2026, 9, 8),
  trip: andalucia
)

# Day 1 – Arrival Sevilla

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

# Day 2 – Sevilla walking tour

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

# Day 3 – Free day

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

# Day 4 – Sevilla to Granada

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

# Day 5 – Granada tour

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

# Day 6 – Granada to Malaga

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

# Day 7 – Beach day

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

# Day 8 – Departure

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
