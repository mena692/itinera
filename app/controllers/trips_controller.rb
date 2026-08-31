class TripsController < ApplicationController
  before_action :authenticate_user!
  NO_ACTIVITIES_SENTINEL = Time.new(9999, 12, 31).freeze

  TOPICS = %w[
    group_size
    vibe
    budget
    pace
    interests
    must_sees
    transportation
  ].freeze

  QUESTIONS = {
    "group_size" => "How many people are in your travel group?",
    "vibe" => "What vibe are you looking for: relaxed, adventurous, cultural, or a mix?",
    "budget" => "What is your approximate total budget for the trip?",
    "pace" => "What pace do you prefer: relaxed, balanced, or packed?",
    "interests" => "What activities or interests would you most like to include?",
    "must_sees" => "Is there anything you absolutely want to see or do?",
    "transportation" => "Will you have a rental car, use public transportation, or prefer tours and transfers?"
  }.freeze

  def new
    @trip = Trip.new
    authorize @trip
  end

  def create
    @trip = current_user.trips.build(trip_params)
    authorize @trip

    start_date = Date.parse(params[:trip][:start_date])
    end_date = Date.parse(params[:trip][:end_date])

    if end_date < start_date
      @trip.errors.add(:base, "End date must be after start date")
      return render :new, status: :unprocessable_entity
    end

    if @trip.save
      create_trip_days(start_date, end_date)

      @chat = @trip.chats.create!(
        user: current_user,
        title: Chat::DEFAULT_TITLE,
        status: "Draft",
        system_prompt: itinerary_system_prompt
      )

      @chat.messages.create!(
        role: "assistant",
        content: "Let's get your trip going! How many people are traveling? (1, 2, 3, 4+)"
      )

      redirect_to trip_chat_path(@trip, @chat)
    else
      render :new, status: :unprocessable_entity
    end
  rescue Date::Error, TypeError
    @trip.errors.add(:base, "Please select valid travel dates")
    render :new, status: :unprocessable_entity
  end

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

  def destroy
    @trip = current_user.trips.find(params[:id])
    authorize @trip
    @trip.destroy

    if current_user.trips.exists?
      redirect_to trips_path
    else
      redirect_to new_trip_path
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:destination, :description)
  end

  def create_trip_days(start_date, end_date)
    (start_date..end_date).each_with_index do |date, index|
      @trip.trip_days.create!(
        name: "Day #{index + 1}",
        date: date
      )
    end
  end

  def itinerary_system_prompt
    <<~PROMPT
      You are Itinera, a travel itinerary planner.

      Your goal is to collect only the information needed to create
      a personalized and realistic itinerary.

      Use everything the user already provided as known context.

      Do not ask for information that is already known.
      Do not ask unnecessary questions.
      Ask only one concise clarification question at a time.

      Once enough context is available, stop asking questions
      and allow the user to generate their itinerary.
    PROMPT
  end

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
