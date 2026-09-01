class ApplicationTool < RubyLLM::Tool
  def initialize(trip:)
    @trip = trip
  end

  private

  def find_trip_day(trip_day_id)
    @trip.trip_days.find(trip_day_id)
  end

  def find_activity(activity_id)
    Activity.joins(:trip_day).where(trip_days: { trip_id: @trip.id }).find(activity_id)
  end

  def compute_start_date(trip_day, start_time)
    Time.zone.parse("#{trip_day.date} #{start_time}")
  end

  def invalid_category_error(category)
    return nil if category.nil? || Activity::CATEGORIES.include?(category)

    "Invalid category #{category.inspect}. Must be one of: #{Activity::CATEGORIES.join(', ')}"
  end
end
