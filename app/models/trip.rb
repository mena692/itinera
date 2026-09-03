class Trip < ApplicationRecord
  belongs_to :user

  has_many :trip_days, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :destination, presence: true

  attr_accessor :start_date, :end_date

  DEFAULT_IMAGE_URL = "activity-placeholder.svg"

  before_validation :assign_default_image_url

  def first_day
    trip_days.minimum(:date)
  end

  def last_day
    trip_days.maximum(:date)
  end

  def number_of_nights
    return 0 unless first_day && last_day

    (last_day - first_day).to_i
  # :past, :current (today falls within the trip), or :future
  end
  def status
    dates = trip_days.map(&:date)
    return :future if dates.empty?

    today = Date.current
    return :current if today.between?(dates.min, dates.max)
    return :past if dates.max < today

    :future
  end

  def activities_count
    trip_days.sum { |trip_day| trip_day.activities.size }
  end

  def first_activity
    trip_days.flat_map(&:activities).min_by(&:start_date)
  end

  private

  def assign_default_image_url
    self.image_url = DEFAULT_IMAGE_URL if image_url.blank?
  end
end
