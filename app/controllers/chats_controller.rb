class ChatsController < ApplicationController
  def show
    @trip = current_user.trips.find(params[:trip_id])
    authorize @trip

    @chat = @trip.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @trip = current_user.trips.find(params[:trip_id])
    authorize @trip

    @chat = @trip.chats.create!(user: current_user, title: Chat::DEFAULT_TITLE)
    @chat.messages.create!(role: "assistant", content: trip_summary_message)

    redirect_to trip_chat_path(@trip, @chat)
  end

  private

  def trip_summary_message
    lines = ["Here's where things stand for your trip to #{@trip.destination}:", "", "Dates: #{trip_dates}"]
    lines << "Travelers: #{@trip.group_size}" if @trip.group_size.present?
    lines << "Vibe: #{@trip.vibe}" if @trip.vibe.present?
    lines << "Notes: #{@trip.description}" if @trip.description.present?
    lines << "Activities planned so far: #{@trip.activities_count}"
    lines << ""
    lines << "What would you like help with?"

    lines.join("\n")
  end

  def trip_dates
    return "not set yet" unless @trip.first_day && @trip.last_day

    "#{@trip.first_day.strftime('%b %-d')}-#{@trip.last_day.strftime('%-d')}"
  end
end
