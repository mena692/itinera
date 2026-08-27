class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are Itinera, a travel itinerary generator.
    Help the user create a realistic itinerary for the specific trip
    provided in the current context.
    Focus on destination, exact TripDay dates, group size, budget,
    pace, interests, food preferences, must-see places and realistic travel time.
    Ask concise follow-up questions when important information is missing.
    Answer concisely in Markdown."

  def new
    @message = Message.new
  end

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @career_path = @chat.career_path
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      Turbo::StreamsChannel.broadcast_append_to(
        @chat,
        target: "messages",
        partial: "messages/message",
        locals: { message: @message }
      )

      @assistant_message = @chat.messages.create(
        role: "assistant",
        content: ""
      )

      ask_llm

      @chat.generate_title_from_first_message

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_message_container",
            partial: "messages/form",
            locals: { chat: @chat, message: @message }
          )
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  # def update
  #   @message = @message.saved
  #   @career_advice = @message
  # end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(message)
    end
  end

  def career_path_context
    "The career path the user is currently exploring is #{@career_path.name}. Here is its description: #{@career_path.description}. The student will have learn the : #{@career_path.course_content}"
  end

  def instructions
    [SYSTEM_PROMPT, career_path_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def ask_llm
    @ruby_llm_chat = RubyLLM.chat

    build_conversation_history
    @ruby_llm_chat.with_tool(SearchCareerPathsTool.new(career_path: @career_path))

    @ruby_llm_chat.with_tool(SaveAdviceTool.new(chat: @chat))

    @ruby_llm_chat.with_instructions(instructions)

    @ruby_llm_chat.ask(@message.content) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
    @assistant_message.save
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target: helpers.dom_id(message),
      partial: "messages/message",
      locals: { message: message }
    )
  end
end
