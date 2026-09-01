class MessagesController < ApplicationController
  QUESTIONS = [
    {
      key: :group_size,
      instruction: "Ask how many people are traveling. Give simple examples like 1, 2, 3, or 4+."
    },
    {
      key: :vibe,
      instruction: "Ask what vibe they want. Give options like relaxed, adventurous, lively, or a mix."
    },
    {
      key: :budget,
      instruction: "Ask for their approximate budget per day. They can give an amount or say budget, moderate, or luxury."
    },
    {
      key: :pace,
      instruction: "Ask what pace they prefer. Give options like chill, balanced, or packed."
    },
    {
      key: :interests,
      instruction: "Ask about their main interests. Give options like nature, food, culture, nightlife, adventure, or a mix."
    },
    {
      key: :must_see,
      instruction: "Ask if there is anything they definitely want to see or do. Make it clear that 'nothing specific' is completely fine."
    },
    {
      key: :transportation,
      instruction: "Ask how they prefer to get around. Give options like walking, public transport, car rental, rideshare, or a mix."
    }
  ].freeze

  CONVERSATION_PROMPT = PromptTemplate.read("messages/conversation")
  SUMMARY_PROMPT = PromptTemplate.read("messages/summary")
  ITINERARY_PROMPT = PromptTemplate.read("messages/itinerary")

  MODIFY_PROMPT = <<~PROMPT
    You are Itinera, a travel itinerary planner.

    The trip already has an itinerary. The user is asking for a change to it.

    You will be given the current itinerary, with the real database ID of
    every day and activity, plus the user's request.

    Use the available tools to make the change directly. Only touch what the
    request implies — do not restructure or rewrite days or activities the
    user didn't ask about.

    Respect the trip's known budget, vibe, pace, interests, must-see
    requests, and transportation preferences when adding or changing
    activities. Consider realistic travel time, opening hours, and sensible
    sequencing.

    If the request is ambiguous or conflicts with a known trip constraint,
    make the most reasonable choice and say so in your reply rather than
    guessing silently or refusing.

    Do not invent specific venues, restaurants, or attractions you are not
    confident exist. Prefer a general description over a fabricated name
    when unsure.

    After using the tools, reply with a short (1-3 sentence) confirmation of
    what changed. Do not restate the full itinerary.
  PROMPT

  def create
    @trip = current_user.trips.find(params[:trip_id])
    authorize @trip

    @chat = @trip.chats.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      broadcast_append(@message)

      @assistant_message = @chat.messages.create!(
        role: "assistant",
        content: ""
      )

      broadcast_append(@assistant_message)

      continue_conversation

      if @redirect_to_trip
        redirect_to trip_path(@trip), status: :see_other
        return
      end

      respond_to do |format|
        format.turbo_stream

        format.html do
          redirect_to trip_chat_path(@trip, @chat)
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_message_container",
            partial: "messages/form",
            locals: {
              trip: @trip,
              chat: @chat,
              message: @message
            }
          )
        end

        format.html do
          render "chats/show", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def continue_conversation
    if full_itinerary_request?
      generate_itinerary
      return
    end

    if trip_has_itinerary?
      handle_modification_request
      return
    end

    if questionnaire_complete?
      generate_summary
      return
    end

    ask_next_question
  end

  def questionnaire_complete?
    questionnaire_answers.count >= QUESTIONS.length
  end

  def ask_next_question
    question = QUESTIONS[questionnaire_answers.count]

    ruby_llm_chat = build_chat_history

    response = ruby_llm_chat
               .with_instructions(
                 [
                   CONVERSATION_PROMPT,
                   trip_context,
                   "NEXT PREFERENCE: #{question[:key]}",
                   "INSTRUCTION: #{question[:instruction]}"
                 ].join("\n\n")
               )
               .ask(@message.content)

    set_assistant_message(response.content)
  end

  def questionnaire_answers
    @chat.messages
         .where(role: "user")
         .order(:created_at)
         .limit(QUESTIONS.length)
  end

  def questionnaire_context
    answers = questionnaire_answers

    lines = QUESTIONS.each_with_index.map do |question, index|
      answer = answers[index]&.content || "Not provided"
      "#{question[:key]}: #{answer}"
    end

    <<~CONTEXT
      QUESTIONNAIRE ANSWERS

      #{lines.join("\n")}
    CONTEXT
  end

  def build_chat_history
    ruby_llm_chat = RubyLLM.chat

    @chat.messages.order(:created_at).each do |message|
      next if message.content.blank?
      next if message == @assistant_message
      next if message == @message
      next if message.content.start_with?("SUMMARY_READY")

      ruby_llm_chat.add_message(message)
    end

    ruby_llm_chat
  end

  def full_itinerary_request?
    text = @message.content.to_s.downcase.strip

    text.include?("generate itinerary") ||
      text.include?("generate full itinerary") ||
      text.include?("create itinerary") ||
      text.include?("create full itinerary")
  end

  def generate_summary
    summary_chat = RubyLLM.chat

    response = summary_chat
               .with_instructions(
                 [
                   SUMMARY_PROMPT,
                   trip_context,
                   questionnaire_context
                 ].join("\n\n")
               )
               .ask("Create the trip recap.")

    set_assistant_message(
      "SUMMARY_READY\n#{response.content}"
    )
  end

  def trip_has_itinerary?
    @trip.activities_count.positive?
  end

  def handle_modification_request
    tools = [
      CreateActivityTool.new(trip: @trip),
      UpdateActivityTool.new(trip: @trip),
      DeleteActivityTool.new(trip: @trip),
      CreateTripDayTool.new(trip: @trip),
      UpdateTripDayTool.new(trip: @trip),
      DeleteTripDayTool.new(trip: @trip),
      UpdateTripTool.new(trip: @trip)
    ]

    modify_chat = RubyLLM.chat

    response = modify_chat
               .with_tools(*tools)
               .with_instructions(
                 [
                   MODIFY_PROMPT,
                   trip_context,
                   modification_context
                 ].join("\n\n")
               )
               .ask(@message.content)

    set_assistant_message(response.content)
  end

  def modification_context
    trip_days = @trip.trip_days.order(:date).includes(:activities)

    lines = ["CURRENT ITINERARY", ""]

    trip_days.each_with_index do |trip_day, index|
      lines << "Day #{index + 1} (trip_day_id: #{trip_day.id}) — #{trip_day.date} — #{trip_day.name}"

      trip_day.activities.order(:start_date).each do |activity|
        times = "#{activity.start_date&.strftime('%H:%M')}–#{activity.end_date&.strftime('%H:%M')}"
        lines << "  - activity_id #{activity.id}: #{activity.name} (#{activity.category}) " \
                 "#{times} at #{activity.address}"
      end

      lines << ""
    end

    lines.join("\n")
  end

  def trip_context
    dates = @trip.trip_days
                 .order(:date)
                 .pluck(:date)
                 .map(&:to_s)
                 .join(", ")

    <<~CONTEXT
      TRIP INFORMATION

      Destination:
      #{@trip.destination}

      Exact trip dates:
      #{dates}

      Original trip description:
      #{@trip.description.presence || 'None provided'}

      Group size:
      #{@trip.group_size.presence || 'Not provided'}

      Vibe:
      #{@trip.vibe.presence || 'Not provided'}

      IMPORTANT:
      Treat the original trip description as authoritative user context.
      Do not ignore preferences or constraints stated there.
    CONTEXT
  end

  def set_assistant_message(content)
    @assistant_message.update!(content: content)
    broadcast_replace(@assistant_message)
  end

  def broadcast_append(message)
    Turbo::StreamsChannel.broadcast_append_to(
      @chat,
      target: "messages",
      partial: "messages/message",
      locals: {
        message: message
      }
    )
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target: helpers.dom_id(message),
      partial: "messages/message",
      locals: {
        message: message
      }
    )
  end

  def generate_itinerary
    ruby_llm_chat = RubyLLM.chat

    Rails.logger.info "=" * 80
    Rails.logger.info "TRIP CONTEXT SENT TO LLM"
    Rails.logger.info trip_context
    Rails.logger.info "=" * 80

    response = ruby_llm_chat
              .with_instructions(
                [
                  ITINERARY_PROMPT,
                  trip_context,
                  questionnaire_context
                ].join("\n\n")
              )
              .ask("Generate the detailed itinerary using the trip information provided.")

    print_generated_itinerary(response.content)
    save_generated_itinerary(response.content)

    @assistant_message.destroy!
    @redirect_to_trip = true
  end

  def print_generated_itinerary(content)
    Rails.logger.info "\n\n"
    Rails.logger.info "=" * 80
    Rails.logger.info "GENERATED ITINERARY"
    Rails.logger.info "=" * 80
    Rails.logger.info content
    Rails.logger.info "=" * 80
    Rails.logger.info "\n\n"
  end

  def save_generated_itinerary(content)
    data = JSON.parse(content)

    data.fetch("days").each do |day_data|
      trip_day = @trip.trip_days.find_by!(
        date: Date.parse(day_data.fetch("date"))
      )

      day_data.fetch("activities").each do |activity_data|
        start_date = Time.zone.parse(
          "#{trip_day.date} #{activity_data.fetch("start_time")}"
        )

        trip_day.activities.create!(
          name: activity_data.fetch("name"),
          category: activity_data.fetch("category"),
          address: activity_data.fetch("address"),
          description: activity_data.fetch("description"),
          notes: activity_data["notes"],
          start_date: start_date,
          end_date: start_date + activity_data.fetch("duration_minutes").minutes
        )
      end
    end
  end
end
