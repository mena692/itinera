class GenerateItineraryJob < ApplicationJob
  queue_as :default

  ITINERARY_PROMPT = PromptTemplate.read("messages/itinerary")

  def perform(trip:, chat:, assistant_message:, trip_context:, questionnaire_context:)
    response = RubyLLM.chat
                      .with_instructions(
                        [
                          ITINERARY_PROMPT,
                          trip_context,
                          questionnaire_context
                        ].join("\n\n")
                      )
                      .ask("Generate the detailed itinerary using the trip information provided.")

    save_generated_itinerary(trip, response.content)

    assistant_message.update!(content: "Your itinerary is ready! Taking you there now...")
    broadcast_replace(chat, assistant_message)
    broadcast_redirect(chat, trip)
  rescue StandardError => e
    Rails.logger.error("GenerateItineraryJob failed for trip #{trip.id}: #{e.class} #{e.message}")

    assistant_message.update!(
      content: "Something went wrong generating your itinerary. Please try again."
    )
    broadcast_replace(chat, assistant_message)
  end

  private

  def save_generated_itinerary(trip, content)
    data = JSON.parse(content)

    data.fetch("days").each do |day_data|
      trip_day = trip.trip_days.find_by!(
        date: Date.parse(day_data.fetch("date"))
      )

      trip_day.update!(
        name: day_data.fetch("name"),
        description: day_data.fetch("description")
      )

      day_data.fetch("activities").each do |activity_data|
        start_date = Time.zone.parse(
          "#{trip_day.date} #{activity_data.fetch('start_time')}"
        )

        category = activity_data.fetch("category")

        category = "sightseeing" unless Activity::CATEGORIES.include?(category)

        trip_day.activities.create!(
          name: activity_data.fetch("name"),
          category: category,
          address: activity_data.fetch("address"),
          description: activity_data.fetch("description"),
          notes: activity_data.fetch("notes"),
          start_date: start_date,
          end_date: start_date + activity_data.fetch("duration_minutes").minutes
        )
      end
    end
  end

  def broadcast_replace(chat, message)
    Turbo::StreamsChannel.broadcast_replace_to(
      chat,
      target: ActionView::RecordIdentifier.dom_id(message),
      partial: "messages/message",
      locals: {
        message: message
      }
    )
  end

  def broadcast_redirect(chat, trip)
    Turbo::StreamsChannel.broadcast_action_to(
      chat,
      action: :redirect,
      attributes: {
        url: Rails.application.routes.url_helpers.trip_path(trip)
      }
    )
  end
end
