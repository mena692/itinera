# Looks up a real travel photo for a destination via the Unsplash API.
#
# Returns an image URL (String) on success, or nil if no key is configured,
# no photo was found, or the request fails for any reason — callers decide
# the fallback, this class never raises.
class TripImageFinder
  ENDPOINT = "https://api.unsplash.com/search/photos"
  OPEN_TIMEOUT = 4
  READ_TIMEOUT = 4
  RESULTS_TO_SAMPLE_FROM = 10

  def self.call(destination)
    new(destination).call
  end

  def initialize(destination)
    @destination = destination
  end

  def call
    return nil if @destination.blank? || access_key.blank?
    return nil if Rails.env.test? # keep the test suite hermetic, never hits the network

    photo = fetch_photo
    photo&.dig("urls", "regular")
  rescue StandardError => e
    Rails.logger.warn("TripImageFinder failed for #{@destination.inspect}: #{e.class} #{e.message}")
    nil
  end

  private

  def fetch_photo
    response = http_get(search_uri)
    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)["results"].presence&.sample
  end

  def search_uri
    uri = URI(ENDPOINT)
    uri.query = URI.encode_www_form(
      query: "#{@destination} travel",
      orientation: "landscape",
      content_filter: "high",
      per_page: RESULTS_TO_SAMPLE_FROM
    )
    uri
  end

  def http_get(uri)
    options = { use_ssl: true, open_timeout: OPEN_TIMEOUT, read_timeout: READ_TIMEOUT }

    Net::HTTP.start(uri.host, uri.port, options) do |http|
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Client-ID #{access_key}"
      request["Accept-Version"] = "v1"
      http.request(request)
    end
  end

  def access_key
    Rails.application.credentials.dig(:unsplash, :access_key).presence || ENV.fetch("UNSPLASH_ACCESS_KEY", nil)
  end
end
