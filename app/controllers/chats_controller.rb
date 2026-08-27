class ChatsController < ApplicationController
  def index
    @chats = current_user.chats.includes(:trip).order(updated_at: :desc)
  end

  def new
    @chat = Chat.new
  end

  def create
    @trip_path = TripPath.find(params[:trip_path_id])
    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.trip_path = @trip_path
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @trip_path.chats.where(user: current_user)
      render "trip_path/show"
    end
  end

  # Path: trips/trip_id/chats/chat_id
  def show
    @trip = current_user.trips.find(params[:trip_id])
    authorize @trip
    @chat = @trip.chats.find(params[:id])
    @message = Message.new
  end

  # def destroy
  #   @chat = current_user.chats.find(params[:id])
  #   @chat.destroy
  # end\

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
