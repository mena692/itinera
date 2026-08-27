class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show edit update destroy]

  def show
    authorize @activity
    @day_number = day_number_for(@activity)
  end

  def edit
    authorize @activity
    @day_number = day_number_for(@activity)
  end

  def update
    authorize @activity

    if @activity.update(update_params)
      redirect_to @activity, notice: "Activity updated."
    else
      @day_number = day_number_for(@activity)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @activity
    trip = @activity.trip_day.trip
    day_number = day_number_for(@activity)
    @activity.destroy
    redirect_to trip_path(trip, day: day_number), notice: "Activity deleted."
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def day_number_for(activity)
    trip = activity.trip_day.trip
    trip.trip_days.order(:date).pluck(:id).index(activity.trip_day_id) + 1
  end

  def activity_params
    params.require(:activity).permit(
      :name, :description, :category, :address,
      :latitude, :longitude, :start_date, :end_date, :notes
    )
  end

  # The edit form only lets users change the time of day, not the date, so
  # the submitted start_time/end_time are merged onto the activity's
  # existing (unchangeable) date before mass-assignment.
  def update_params
    raw = params.require(:activity)
    raw[:start_date] = combine_date_and_time(@activity.start_date, raw.delete(:start_time))
    raw[:end_date] = combine_date_and_time(@activity.end_date, raw.delete(:end_time))
    activity_params
  end

  def combine_date_and_time(original_datetime, time_string)
    return original_datetime if time_string.blank?

    hour, minute = time_string.split(":").map(&:to_i)
    original_datetime.change(hour: hour, min: minute)
  end
end
