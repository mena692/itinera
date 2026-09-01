class UpdateTripTool < ApplicationTool
  description "Updates the trip's own details (not a specific day or activity)."
  param :destination, desc: "New destination", required: false
  param :name, desc: "New trip name", required: false
  param :description, desc: "New trip description", required: false
  param :group_size, type: :integer, desc: "New group size", required: false
  param :vibe, desc: "New trip vibe", required: false

  def execute(**changes)
    attrs = changes.slice(:destination, :name, :description, :group_size, :vibe).compact

    @trip.update!(attrs)

    { status: "ok", trip_id: @trip.id }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
