class ChatsController < ApplicationController
  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.user = current_user
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render "chats/show"
    end
  end
end
