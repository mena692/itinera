class Trip < ApplicationRecord
  belongs_to :user
  has_many :trip_days, dependent: :destroy
  has_many :chats, dependent: :destroy
end
