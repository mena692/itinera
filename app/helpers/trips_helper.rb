module TripsHelper
  def trip_date_range_label(trip)
    dates = trip.trip_days.map(&:date).sort
    return "" if dates.empty?

    first_date = dates.first
    last_date = dates.last

    return first_date.strftime("%-d %b %Y") if first_date == last_date
    return "#{first_date.day}–#{last_date.strftime('%-d %b %Y')}" if same_month?(first_date, last_date)

    start_format = first_date.year == last_date.year ? "%-d %b" : "%-d %b %Y"
    "#{first_date.strftime(start_format)} – #{last_date.strftime('%-d %b %Y')}"
  end

  # Where the trip card/hero link should go: back into the resumable
  # chat while it's unfinished, or to the itinerary once it's done.
  # Falls back to the itinerary path if there's no chat to resume (e.g.
  # a trip created outside the normal flow, with no chat at all).
  def trip_resume_path(trip)
    return trip_path(trip) if trip.itinerary_generated? || trip.primary_chat.nil?

    trip_chat_path(trip, trip.primary_chat)
  end

  def trip_resume_cta_label(trip)
    trip.itinerary_generated? ? "view itinerary" : "continue planning"
  end

  def trip_countdown_label(trip)
    dates = trip.trip_days.map(&:date)
    return nil if dates.empty?

    return "ongoing" if dates.include?(Date.current)

    days = (dates.min - Date.current).to_i
    return nil unless days.positive?

    "in #{days} #{'day'.pluralize(days)}"
  end

  private

  def same_month?(first_date, last_date)
    first_date.year == last_date.year && first_date.month == last_date.month
  end
end
