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
