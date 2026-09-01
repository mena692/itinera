class CreateTripDayTool < ApplicationTool
  description "Adds a new day to the trip, e.g. when the user extends their trip."
  param :date, desc: "Date of the new day, in YYYY-MM-DD format"
  param :name, desc: "Short theme for the day", required: false
  param :description, desc: "Short description of the day", required: false

  def execute(date:, name: nil, description: nil)
    trip_day = @trip.trip_days.create!(
      date: Date.parse(date),
      name: name,
      description: description
    )

    { status: "ok", trip_day_id: trip_day.id }
  rescue ActiveRecord::RecordInvalid, Date::Error, TypeError => e
    { error: e.message }
  end
end
