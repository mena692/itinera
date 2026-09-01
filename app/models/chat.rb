class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  has_many :messages, dependent: :destroy
  DEFAULT_TITLE = "Drafting Itinerary"
  validates :title, presence: true
  # Only one code path ever creates a Chat (TripsController#create), but
  # nothing at the DB level enforced that — this documents and guards it.
  validates :trip_id, uniqueness: true

  TITLE_PROMPT = <<~PROMPT
    Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
  PROMPT

  def generate_title_from_first_message
    return unless title == DEFAULT_TITLE

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(first_user_message.content)
    update(title: response.content)
  end
end
