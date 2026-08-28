class TripsController < ApplicationController
  NO_ACTIVITIES_SENTINEL = Time.new(9999, 12, 31).freeze

  def index
    @trips = policy_scope(Trip).includes(trip_days: :activities).to_a
    @trips = @trips.sort_by { |trip| earliest_activity_start_for(trip) }
    @upcoming_trip = find_upcoming_trip(@trips)
    @other_trips = @trips - [@upcoming_trip].compact
  end

  def show
    @trip = Trip.find(params[:id])
    authorize @trip
    @trip_days = @trip.trip_days.order(date: :asc)
    @trip_day = @trip_days[params[:day].to_i - 1]
    # @activity = Activity.find(params[:id])
    @activities = @trip_day.activities.order(start_date: :asc)
  end

  private

  # The start time of the earliest activity on a trip's first (earliest-dated) day.
  def earliest_activity_start_for(trip)
    first_day = trip.trip_days.min_by(&:date)
    return NO_ACTIVITIES_SENTINEL unless first_day

    earliest_activity = first_day.activities.min_by(&:start_date)
    earliest_activity&.start_date || NO_ACTIVITIES_SENTINEL
  end

  # The trip that's happening today, or failing that, the soonest trip
  # whose first day is still ahead of us.
  def find_upcoming_trip(trips)
    dated_trips = trips.select { |trip| trip.trip_days.any? }

    ongoing_trip_for(dated_trips) || soonest_future_trip_for(dated_trips)
  end

  def ongoing_trip_for(dated_trips)
    today = Date.current
    dated_trips.find { |trip| trip.trip_days.map(&:date).include?(today) }
  end

  def soonest_future_trip_for(dated_trips)
    today = Date.current
    dated_trips.select { |trip| trip.trip_days.map(&:date).min >= today }
               .min_by { |trip| trip.trip_days.map(&:date).min }
  end
end
