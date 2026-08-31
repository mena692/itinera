import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "latitude", "longitude"]
  static values = { accessToken: String }

  connect() {
    this.debounceTimer = null
  }

  disconnect() {
    clearTimeout(this.debounceTimer)
  }

  search() {
    clearTimeout(this.debounceTimer)
    const query = this.inputTarget.value.trim()

    if (query.length < 3) {
      this.clearResults()
      return
    }

    this.debounceTimer = setTimeout(() => this.fetchResults(query), 300)
  }

  async fetchResults(query) {
    if (!this.accessTokenValue) return

    const url = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json` +
      `?access_token=${encodeURIComponent(this.accessTokenValue)}&autocomplete=true&limit=5`

    const response = await fetch(url)
    if (!response.ok) return

    const data = await response.json()
    this.renderResults(data.features || [])
  }

  renderResults(features) {
    this.resultsTarget.innerHTML = ""

    features.forEach((feature) => {
      const item = document.createElement("button")
      item.type = "button"
      item.className = "address-search__result"
      item.textContent = feature.place_name
      item.addEventListener("click", () => this.select(feature))
      this.resultsTarget.appendChild(item)
    })

    this.resultsTarget.hidden = features.length === 0
  }

  select(feature) {
    this.inputTarget.value = feature.place_name
    this.longitudeTarget.value = feature.center[0]
    this.latitudeTarget.value = feature.center[1]
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.hidden = true
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) this.clearResults()
  }
}
