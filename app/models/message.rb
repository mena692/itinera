class Message < ApplicationRecord
  belongs_to :chat

  MAX_USER_MESSAGES = 100

  validates :role, inclusion: { in: ["user", "assistant"] }
  validates :content, presence: true, unless: :streaming_assistant?

  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
  end

  def streaming_assistant?
    role == "assistant"
  end
end
