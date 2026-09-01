class UpdateTripDayTool < ApplicationTool
  description "Updates a trip day's name or description. Does not change its date."
  param :trip_day_id, type: :integer, desc: "ID of the trip day to update, from the current itinerary context"
  param :name, desc: "New short theme for the day", required: false
  param :description, desc: "New description of the day", required: false

  def execute(trip_day_id:, **changes)
    trip_day = find_trip_day(trip_day_id)
    attrs = changes.slice(:name, :description).compact

    trip_day.update!(attrs)

    { status: "ok", trip_day_id: trip_day.id }
  rescue ActiveRecord::RecordNotFound
    { error: "Trip day #{trip_day_id} not found on this trip" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
