class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  has_many :messages, dependent: :destroy
  DEFAULT_TITLE = "Drafting Itinerary"
  validates :title, presence: true
end
