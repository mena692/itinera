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

  CONVERSATION_PROMPT = <<~PROMPT
    You are Itinera, a friendly travel itinerary planner.

    You are helping the user quickly set up their trip.

    Rails will tell you the ONE preference you should ask about next.

    Ask one short, natural question about that preference.

    Include a few useful options or examples so the question is easy to answer.

    Keep it concise.

    Do not ask about any other trip preference.
    Do not ask follow-up questions about preferences already answered.
    Do not turn one preference into multiple questions.
    Do not generate or summarize the itinerary yet.

    If the user asks for a recommendation instead of directly answering,
    give one short recommendation for the CURRENT preference and ask
    whether that works for them.

    Do not interpret, summarize, or comment on the user's previous answer.

    Simply ask the next question naturally and concisely.

    Keep the entire response to one short sentence whenever possible.

    Do not explain the options unless the user asks for clarification.

    The goal is to finish setup quickly.
  PROMPT

  SUMMARY_PROMPT = <<~PROMPT
    You are Itinera, a travel itinerary planner.

    Create a short recap of the user's trip preferences.

    Use the original trip information and questionnaire answers.

    Do not create the itinerary yet.
    Do not invent information.
    Keep each value short.

    Use exactly this format:

    Travelers: value
    Vibe: value
    Budget: value
    Pace: value
    Interests: value
    Must-see: value
    Transportation: value

    Do not use Markdown.
    Do not add any other text.
  PROMPT

  ITINERARY_PROMPT = <<~PROMPT
    You are Itinera, a travel itinerary planner.

    Create a realistic day-by-day itinerary using ALL known trip information.

    Respect:
    - exact trip dates
    - group size
    - budget
    - vibe
    - preferred pace
    - interests
    - must-see requests
    - transportation preferences

    Use ONLY the exact trip dates listed in TRIP INFORMATION.

    DAY 1 must use the first exact trip date.
    Each following day must use the next exact trip date in order.
    Never invent, shift, or infer different dates.

    Assume the user is arriving at the destination on the first trip date
    and leaving on the last trip date.

    Keep the first and last days lighter and more flexible.

    Do not invent exact arrival times, departure times, flight details,
    airport details, hotel check-in/check-out times, or transportation bookings
    unless the user explicitly provided them.

    Do not ask any more questions.
    Do not add an introduction or conclusion.
    Do not recommend accommodation unless requested.
    Do not include a separate budget breakdown.

    NEVER repeat the same attraction, landmark, neighborhood, museum,
    garden, beach, or venue on different days.

    Before choosing an activity, check all previous days and select
    a different place if it has already been used.

    Every day, including DAY 1 and the FINAL DAY,
    must contain at least one properly formatted activity block.

    The FINAL DAY must NEVER contain free text such as
    "flexible morning", "departure preparations", or similar.

    If the first or last day should be lighter,
    use only 1 or 2 real activities,
    but still use the exact activity format.

    Do not output vague or free-form suggestions such as:
    "flexible morning options",
    "nearby temple",
    "local eateries",
    "if time permits",
    or similar wording.

    The itinerary will later be displayed as activity cards.

    For each day include:
    - day number
    - short day theme
    - exact date
    - approximately 3 to 5 activities when realistic

    For each activity include:
    - start time
    - activity name
    - category
    - duration
    - useful address or area
    - one short description
    - one short note only when useful

    End each day with:
    - number of stops
    - approximate active time
    - main transportation method

    Use EXACTLY this format:

    DAY 1 — Short theme
    Date: exact trip date

    10:00 — Activity name
    Category: culture
    Duration: 1.5 hr
    Address: useful location or area
    Description: One short sentence.
    Notes: Short useful note.

    13:00 — Activity name
    Category: food
    Duration: 1 hr
    Address: useful location or area
    Description: One short sentence.

    Day summary: 2 stops · ~2.5 hr · walking

    Keep it TL;DR:
    - no paragraphs
    - no filler
    - descriptions are one short sentence
    - notes are optional and very short
    - categories should normally be one word
    - keep each field on its own line
    - put a blank line between activities
    - put two blank lines between days
    - do not use Markdown headings, bold text, tables, or bullet symbols
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
end
