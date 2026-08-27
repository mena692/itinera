class ChatsController < ApplicationController
  def show
    @trip = Trip.find(params[:trip_id])
    @chat = @trip.chats.find(params[:id])

    authorize @chat

    @message = Message.new
  end
end
