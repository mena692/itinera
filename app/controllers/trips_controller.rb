class TripsController < ApplicationController
  def show
    @trip = Trip.find(params[:id])
    authorize @trip
    @trip_days = @trip.trip_days.order(date: :asc)
    @trip_day = @trip_days[params[:day].to_i - 1]
    # @activity = Activity.find(params[:id])
    @activities = @trip_day.activities.order(start_date: :asc)
  end
end
