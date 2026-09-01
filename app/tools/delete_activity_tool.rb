class DeleteActivityTool < ApplicationTool
  description "Removes an activity from the trip."
  param :activity_id, type: :integer, desc: "ID of the activity to remove, from the current itinerary context"

  def execute(activity_id:)
    activity = find_activity(activity_id)
    activity.destroy!

    { status: "ok", activity_id: activity_id }
  rescue ActiveRecord::RecordNotFound
    { error: "Activity #{activity_id} not found on this trip" }
  end
end
