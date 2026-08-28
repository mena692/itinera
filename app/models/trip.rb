class Trip < ApplicationRecord
  belongs_to :user
  has_many :trip_days, dependent: :destroy
  has_many :chats, dependent: :destroy

  # :past, :current (today falls within the trip), or :future
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
end
