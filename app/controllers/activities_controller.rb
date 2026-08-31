class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show edit update destroy]

  def new
    set_trip_and_day
    @activity = @trip_day.activities.new
    authorize @activity
  end

  def create
    set_trip_and_day
    @activity = @trip_day.activities.new(create_params)
    authorize @activity

    if @activity.save
      redirect_to trip_path(@trip, day: @day_number), notice: "Activity added."
    else
      render :new, status: :unprocessable_entity
    end
  end

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
      redirect_to [@trip, @activity], notice: "Activity updated."
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
    @trip = @activity.trip_day.trip
  end

  def set_trip_and_day
    @trip = current_user.trips.find(params[:trip_id])
    authorize @trip

    @day_number = (params[:day] || 1).to_i
    @trip_day = @trip.trip_days.order(:date)[@day_number - 1]
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

  # The new form only collects a time of day, so the submitted start_time/end_time
  # are merged onto the trip day's date before mass-assignment.
  def create_params
    raw = params.require(:activity)
    raw[:start_date] = combine_date_and_time(@trip_day.date, raw.delete(:start_time))
    raw[:end_date] = combine_date_and_time(@trip_day.date, raw.delete(:end_time))
    activity_params
  end

  def combine_date_and_time(original_datetime, time_string)
    return original_datetime if time_string.blank?

    hour, minute = time_string.split(":").map(&:to_i)
    original_datetime.in_time_zone.change(hour: hour, min: minute)
  end
end
