class TripsController < ApplicationController
  before_action :authenticate_user!

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
        content: "Great. Tell me a little more: budget, who is travelling, your preferred pace, and anything you absolutely want to do"
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
    @trip_days = @trip.trip_days.includes(:activities).order(:date)
  end

  private

  def trip_params
    params.require(:trip).permit(:destination, :description)
  end

  def create_trip_days(start_date, end_date)
    (start_date..end_date).each_with_index do |date, index|
      @trip.trip_days.create!(
        name: "Day#{index + 1}",
        date: date
      )
    end
  end
end
