class UpdateActivityTool < ApplicationTool
  description "Updates an existing activity's details. Only pass the fields that should change."
  param :activity_id, type: :integer, desc: "ID of the activity to update, from the current itinerary context"
  param :name, desc: "New activity name", required: false
  param :category, desc: "One of: #{Activity::CATEGORIES.join(', ')}", required: false
  param :start_time, desc: "New start time in HH:MM (24-hour) format", required: false
  param :duration_minutes, type: :integer, desc: "New duration in minutes", required: false
  param :address, desc: "New address or area"
  param :description, desc: "New one-sentence description", required: false
  param :notes, desc: "New short note", required: false

  def execute(activity_id:, category: nil, start_time: nil, duration_minutes: nil, **changes)
    error = invalid_category_error(category)
    return { error: error } if error

    activity = find_activity(activity_id)
    attrs = changes.slice(:name, :address, :description, :notes).compact
    attrs[:category] = category if category

    start_date = start_time ? compute_start_date(activity.trip_day, start_time) : activity.start_date
    duration = duration_minutes || ((activity.end_date - activity.start_date) / 60)
    if start_time || duration_minutes
      attrs[:start_date] = start_date
      attrs[:end_date] = start_date + duration.minutes
    end

    activity.update!(attrs)

    { status: "ok", activity_id: activity.id }
  rescue ActiveRecord::RecordNotFound
    { error: "Activity #{activity_id} not found on this trip" }
  rescue ActiveRecord::RecordInvalid, ArgumentError, TypeError => e
    { error: e.message }
  end
end
