class Message < ApplicationRecord
  belongs_to :chat
  validates :content, presence: true, unless: :assistant_streaming?
  validates :role, inclusion: { in: ["user", "assistant"] }

  private

  def assistant_streaming?
    role == "assistant"
  end
end
