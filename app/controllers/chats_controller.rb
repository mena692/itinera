class ChatsController < ApplicationController
  def show
    @trip = current_user.trips.find(params[:trip_id])
    authorize @trip

    @chat = @trip.chats.find(params[:id])
    @message = Message.new
  end
end
