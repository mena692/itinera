class CreateActivityTool < ApplicationTool
  description "Adds a new activity to a specific day of the trip."
  param :trip_day_id, type: :integer, desc: "ID of the trip day to add the activity to (from the current itinerary)"
  param :name, desc: "Name of the activity or place"
  param :category, desc: "One of: #{Activity::CATEGORIES.join(', ')}"
  param :start_time, desc: "Start time in HH:MM (24-hour) format"
  param :duration_minutes, type: :integer, desc: "Duration of the activity in minutes"
  param :address, desc: "Address or area useful for the activity", required: false
  param :description, desc: "One short sentence describing the activity", required: false
  param :notes, desc: "Optional short note", required: false

  def execute(trip_day_id:, name:, category:, start_time:, duration_minutes:, **optional)
    error = invalid_category_error(category)
    return { error: error } if error

    trip_day = find_trip_day(trip_day_id)
    start_date = compute_start_date(trip_day, start_time)

    activity = trip_day.activities.create!(
      optional.slice(:address, :description, :notes).merge(
        name: name,
        category: category,
        start_date: start_date,
        end_date: start_date + duration_minutes.minutes
      )
    )

    { status: "ok", activity_id: activity.id }
  rescue ActiveRecord::RecordNotFound
    { error: "Trip day #{trip_day_id} not found on this trip" }
  rescue ActiveRecord::RecordInvalid, ArgumentError, TypeError => e
    { error: e.message }
  end
end
