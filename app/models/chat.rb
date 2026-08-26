class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  has_many :messages, dependent: :destroy
  DEFAULT_TITLE = "New Chat"
end
