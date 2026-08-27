class TripDay < ApplicationRecord
  belongs_to :trip
  has_many :activities, dependent: :destroy
  validates :date, presence: true
end
