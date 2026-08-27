class Trip < ApplicationRecord
  belongs_to :user

  has_many :trip_days, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :destination, presence: true

  attr_accessor :start_date, :end_date, :dates_flexible

  def first_day
    trip_days.minimum(:date)
  end

  def last_day
    trip_days.maximum(:date)
  end

  def number_of_nights
    return 0 unless first_day && last_day

    (last_day - first_day).to_i
  end
end
