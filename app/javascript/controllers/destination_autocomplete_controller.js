import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "selection"]
  static values = { accessToken: String }

  connect() {
    this.timeout = null

    this.form = this.element.closest("form")
    this.form.addEventListener("submit", this.validateSelection)

    this.invalidateSelection()
  }

  disconnect() {
    this.form.removeEventListener("submit", this.validateSelection)
  }

  validateSelection = (event) => {
    if (this.selectionTarget.value === "") {
      event.preventDefault()

      this.inputTarget.setCustomValidity(
        "Please select a destination from the suggestions."
      )

      this.inputTarget.reportValidity()
    }
  }

  search() {
    clearTimeout(this.timeout)

    this.invalidateSelection()

    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.clearResults()
      return
    }

    this.timeout = setTimeout(() => {
      this.fetchResults(query)
    }, 300)
  }

  async fetchResults(query) {
    const url =
      `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json` +
      `?access_token=${this.accessTokenValue}` +
      `&autocomplete=true` +
      `&types=place,country`

    const response = await fetch(url)
    const data = await response.json()

    this.renderResults(data.features)
  }

  renderResults(features) {
    this.resultsTarget.innerHTML = ""

    features.slice(0, 5).forEach((feature) => {
      const option = document.createElement("button")

      option.type = "button"
      option.className = "destination-autocomplete-option"
      option.textContent = feature.place_name

      option.addEventListener("click", () => {
        this.selectDestination(feature)
      })

      this.resultsTarget.appendChild(option)
    })

    if (features.length > 0) {
      this.resultsTarget.classList.add("show")
    }
  }

  selectDestination(feature) {
    this.inputTarget.value = feature.place_name
    this.selectionTarget.value = feature.id

    this.inputTarget.setCustomValidity("")

    this.clearResults()
  }

  invalidateSelection() {
    this.selectionTarget.value = ""
    this.inputTarget.setCustomValidity(
      "Please select a destination from the suggestions."
    )
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.remove("show")
  }
}
