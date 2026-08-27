class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show edit update destroy]

  def show
    authorize @activity
  end

  def edit
    authorize @activity
  end

  def update
    authorize @activity

    if @activity.update(activity_params)
      redirect_to @activity, notice: "Activity updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @activity
    trip = @activity.trip_day.trip
    day_number = trip.trip_days.order(:date).pluck(:id).index(@activity.trip_day_id) + 1
    @activity.destroy
    redirect_to trip_path(trip, day: day_number), notice: "Activity deleted."
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(
      :name, :description, :category, :address,
      :latitude, :longitude, :start_date, :end_date, :notes
    )
  end
end
