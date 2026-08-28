class TripsController < ApplicationController
  before_action :authenticate_user!

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
        content: initial_chat_message
      )

      redirect_to trip_chat_path(@trip, @chat)
    else
      render :new, status: :unprocessable_entity
    end
  rescue Date::Error, TypeError
    @trip.errors.add(:base, "Please select valid travel dates")
    render :new, status: :unprocessable_entity
  end

  def show
    @trip = current_user.trips.find(params[:id])
    authorize @trip

    @trip_days = @trip.trip_days
                      .includes(:activities)
                      .order(:date)
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

  def initial_chat_message
    next_topic = TOPICS.find do |topic|
      !inferred_topics_from_trip_description.include?(topic)
    end

    if next_topic.present?
      "Let's get your trip going! I just need a few details to personalize it.\n\n#{QUESTIONS[next_topic]}"
    else
      "DRAFT_READY"
    end
  end

  def inferred_topics_from_trip_description
    text = @trip.description.to_s.downcase
    inferred = []

    inferred << "group_size" if text.match?(
      /\b(?:we are|we're|group of|party of)?\s*\d+\s*(?:people|person|travelers|travellers)\b/
    )

    inferred << "vibe" if text.match?(
      /relaxed activities|adventurous trip|cultural trip|romantic trip|party trip|nightlife-focused/
    )

    inferred << "budget" if text.match?(
      /[$€£]\s?\d+|\d+\s?(?:usd|eur|gbp|dollars|euros)/
    )

    inferred << "pace" if text.match?(
      /relaxed|slow pace|slow-paced|slow paced|fast pace|packed|balanced/
    )

    inferred << "interests" if text.match?(
      /food|museum|museums|nature|coffee|hiking|beach|beaches|nightlife|culture|adventure|adventurous/
    )

    inferred << "must_sees" if text.match?(
      /must-do|must do|must-see|must see|absolutely want|definitely want|don't want to miss/
    )

    inferred << "transportation" if text.match?(
      /no rental car|without a rental car|will not have a rental car|won't have a rental car|public transport|public transportation|rental car|tours|transfers/
    )

    inferred
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
end
