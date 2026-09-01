class Trip < ApplicationRecord
  FALLBACK_IMAGE_URL = "trip-placeholder.svg"

  belongs_to :user

  has_many :trip_days, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :destination, presence: true

  attr_accessor :start_date, :end_date

  after_create_commit :fetch_and_cache_image!

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

  # No title is collected on the new-trip form, so fall back to the
  # destination until one is set (e.g. by the itinerary chat). Suffixed
  # with the owner's first name when known, e.g. "Lisbon (Thomas)" —
  # never falls back to their email.
  def display_name
    label = name.presence || destination
    return label if user.first_name.blank?

    "#{label} (#{user.first_name})"
  end

  # image_url, once set, is never overwritten — the same photo keeps showing
  # every time the trip is viewed. Falls back to a local asset so views never
  # crash and never make a network call at render time.
  def display_image_url
    image_url.presence || FALLBACK_IMAGE_URL
  end

  # Looks up a photo for the destination and persists it, but only if
  # image_url is still blank. Safe to call more than once (e.g. to retry
  # trips whose initial lookup failed) — never raises.
  def fetch_and_cache_image!
    return if image_url.present?

    found_url = TripImageFinder.call(destination)
    update_column(:image_url, found_url) if found_url.present?
  end
end
