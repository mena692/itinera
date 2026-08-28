class MessagesController < ApplicationController
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

  CLARIFICATIONS = {
    "group_size" => "I mean the total number of people traveling. How many people are in your group?",
    "vibe" => "By vibe I mean the overall feel of the trip — relaxed, adventurous, cultural, or a mix. Which fits best?",
    "budget" => "I mean roughly how much you want to spend on the whole trip. What is your approximate total budget?",
    "pace" => "By pace I mean how busy you want each day to be — relaxed, balanced, or packed. Which fits best?",
    "interests" => "I mean activities you would enjoy, such as hiking, museums, beaches, nightlife, or adventure activities. What interests you most?",
    "must_sees" => "I mean anything you definitely don't want to miss. If you don't have anything specific, you can say no.",
    "transportation" => "I mean how you would prefer to get around — rental car, public transportation, or tours and transfers."
  }.freeze

  SUMMARY_PROMPT = <<~PROMPT
    You are Itinera, a travel itinerary planner.

    The user has finished providing the information needed for their trip.

    Create a short recap using ALL known trip information.

    Do not create an itinerary.
    Do not suggest activities.
    Do not break the trip down by day.
    Do not add an introduction or conclusion.

    Extract the user's actual preferences from the original trip description
    and the conversation.

    Keep answers short and natural.

    Use EXACTLY these fields and EXACTLY this format:

    Travelers: value
    Vibe: value
    Budget: value
    Pace: value
    Interests: value
    Must-see: value
    Transportation: value

    Do not use Markdown.
    Do not add any other fields.
  PROMPT

  ITINERARY_PROMPT = <<~PROMPT
    You are Itinera, a travel itinerary planner.

    You now have enough context to create the user's detailed itinerary.

    Create a realistic day-by-day itinerary using ALL known trip information.

    Respect:
    - exact trip dates
    - group size
    - budget
    - vibe
    - preferred pace
    - interests
    - must-see requests
    - transportation constraints
    - timing preferences

    Do not ask any more questions.
    Do not add an introduction or conclusion.
    Do not recommend accommodation unless requested.
    Do not include a separate budget breakdown.
    Do not repeat attractions.

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
    Date: Thursday, August 28

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
    topic = last_question_topic

    if topic == "transportation" && recommendation_request?(@message.content)
      set_assistant_message(
        "For this trip, I recommend organized shuttles or tours between regions, then walking or public transportation locally. Does that work for you?"
      )
      return
    end

    if transportation_confirmation?
      generate_summary
      return
    end

    if clarification_complete?
      if full_itinerary_request?
        generate_itinerary
      else
        generate_summary
      end

      return
    end

    if topic.present? && clarification_request?(@message.content, topic)
      set_assistant_message(CLARIFICATIONS[topic])
      return
    end

    next_topic = TOPICS.find do |item|
      !completed_topics.include?(item)
    end

    if next_topic.present?
      set_assistant_message(QUESTIONS[next_topic])
    else
      generate_summary
    end
  end

  def clarification_complete?
    TOPICS.all? do |topic|
      completed_topics.include?(topic)
    end
  end

  def recommendation_request?(content)
    text = content.to_s.downcase.strip

    recommendation_phrases = [
      "not sure",
      "i'm not sure",
      "im not sure",
      "unsure",
      "i don't know",
      "i dont know",
      "idk",
      "what do you recommend",
      "what would you recommend",
      "what do you suggest",
      "what would you suggest",
      "recommend"
    ]

    recommendation_phrases.include?(text)
  end

  def transportation_confirmation?
    return false unless last_question_topic == "transportation"

    previous_assistant = @chat.messages
                              .where(role: "assistant")
                              .where.not(id: @assistant_message.id)
                              .order(created_at: :desc)
                              .first

    return false unless previous_assistant&.content&.include?(
      "I recommend organized shuttles or tours"
    )

    confirmation?(@message.content)
  end

  def confirmation?(content)
    text = content.to_s.downcase.strip

    [
      "yes",
      "yeah",
      "yep",
      "sure",
      "sounds good",
      "that works",
      "works for me",
      "ok",
      "okay"
    ].include?(text)
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

    @chat.messages.order(:created_at).each do |message|
      next if message.content.blank?
      next if message == @assistant_message
      next if message.content.start_with?("SUMMARY_READY")

      summary_chat.add_message(message)
    end

    response = summary_chat
                 .with_instructions(
                   [SUMMARY_PROMPT, trip_context].join("\n\n")
                 )
                 .ask("Create the trip recap.")

    set_assistant_message(
      "SUMMARY_READY\n#{response.content}"
    )
  end

  def generate_itinerary
    ruby_llm_chat = RubyLLM.chat

    @chat.messages.order(:created_at).each do |message|
      next if message.content.blank?
      next if message.content.start_with?("SUMMARY_READY")
      next if message == @assistant_message
      next if message == @message

      ruby_llm_chat.add_message(message)
    end

    response = ruby_llm_chat
                 .with_instructions(
                   [ITINERARY_PROMPT, trip_context].join("\n\n")
                 )
                 .ask(@message.content)

    @assistant_message.destroy!

    @redirect_to_trip = true
  end

  def completed_topics
    completed = []

    messages = @chat.messages
                    .where.not(id: @assistant_message.id)
                    .order(:created_at)

    pending_topic = nil

    messages.each do |message|
      if message.role == "assistant"
        detected_topic = topic_from_question(message.content)
        pending_topic = detected_topic if detected_topic.present?

      elsif message.role == "user" && pending_topic.present?
        unless clarification_request?(message.content, pending_topic) ||
               recommendation_request?(message.content)

          completed << pending_topic
          pending_topic = nil
        end
      end
    end

    if transportation_recommendation_confirmed?
      completed << "transportation"
    end

    (completed + inferred_topics_from_trip_description).uniq
  end

  def transportation_recommendation_confirmed?
    messages = @chat.messages.order(:created_at)

    recommendation_seen = false

    messages.each do |message|
      if message.role == "assistant" &&
         message.content.to_s.include?("I recommend organized shuttles or tours")

        recommendation_seen = true

      elsif recommendation_seen &&
            message.role == "user" &&
            confirmation?(message.content)

        return true
      end
    end

    false
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

  def last_question_topic
    assistant_messages = @chat.messages
                              .where(role: "assistant")
                              .where.not(id: @assistant_message.id)
                              .order(created_at: :desc)

    assistant_messages.each do |message|
      topic = topic_from_question(message.content)
      return topic if topic.present?
    end

    nil
  end

  def topic_from_question(content)
    text = content.to_s.downcase

    return "group_size" if text.match?(
      /how many people|group size|people.*group/
    )

    return "vibe" if text.match?(
      /vibe|overall feel/
    )

    return "budget" if text.match?(
      /budget|how much.*spend/
    )

    return "pace" if text.match?(
      /pace|relaxed.*balanced|balanced.*packed/
    )

    return "interests" if text.match?(
      /interests|activities.*interest|activities would you/
    )

    return "must_sees" if text.match?(
      /must-see|must see|absolutely want|don't want to miss/
    )

    return "transportation" if text.match?(
      /transport|rental car|public transportation|tours.*transfers|organized shuttles/
    )

    nil
  end

  def clarification_request?(content, topic)
    text = content.to_s.downcase.strip

    generic_clarifications = [
      "what?",
      "what",
      "huh",
      "what do you mean",
      "what does that mean",
      "i don't understand",
      "explain"
    ]

    return true if generic_clarifications.include?(text)

    topic_words = {
      "group_size" => ["group size", "people?"],
      "vibe" => ["vibe", "vibe?"],
      "budget" => ["budget", "budget?"],
      "pace" => ["pace", "pace?"],
      "interests" => ["interests?", "activities?"],
      "must_sees" => ["must see?", "must-see?"],
      "transportation" => ["transportation?", "transport?"]
    }

    topic_words.fetch(topic, []).include?(text)
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
      #{@trip.description.presence || "None provided"}

      Group size:
      #{@trip.group_size.presence || "Infer from the original description or conversation"}

      Vibe:
      #{@trip.vibe.presence || "Infer from the original description or conversation"}

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
end
