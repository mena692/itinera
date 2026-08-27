class Message < ApplicationRecord
  belongs_to :chat
  validates :role, inclusion: { in: ["user", "assistant"] }
  validates :content, presence: true, unless: :streaming_assistant?
  MAX_USER_MESSAGES = 5
  validate :user_message_limit, if: -> { role == "user" }

  after_create_commit :broadcast_message, if: -> { role == "assistant" }

  private

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
  end

  def streaming_assistant?
    role == "assistant"
  end

  def broadcast_message
    broadcast_append_to(
      chat,
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end
end
