class DeleteTripDayTool < ApplicationTool
  description "Removes a day from the trip, along with all of its activities."
  param :trip_day_id, type: :integer, desc: "ID of the trip day to remove, from the current itinerary context"

  def execute(trip_day_id:)
    trip_day = find_trip_day(trip_day_id)
    trip_day.destroy!

    { status: "ok", trip_day_id: trip_day_id }
  rescue ActiveRecord::RecordNotFound
    { error: "Trip day #{trip_day_id} not found on this trip" }
  end
end
