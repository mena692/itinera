import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    accessToken: String,
    stops: Array
  }

  connect() {
    if (!this.accessTokenValue) {
      console.warn("map controller: missing Mapbox access token")
      return
    }

    mapboxgl.accessToken = this.accessTokenValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/dark-v11",
      center: this.initialCenter(),
      zoom: 12
    })

    this.map.on("load", () => this.renderStops())
  }

  disconnect() {
    if (this.map) this.map.remove()
  }

  initialCenter() {
    const first = this.stopsValue[0]
    return first ? [first.lng, first.lat] : [0, 0]
  }

  renderStops() {
    if (this.stopsValue.length === 0) return

    const bounds = new mapboxgl.LngLatBounds()

    this.stopsValue.forEach((stop, index) => {
      const el = document.createElement("div")
      el.className = "map-marker"
      el.textContent = index + 1

      const popup = new mapboxgl.Popup({ offset: 16 }).setText(stop.name || stop.address)
      popup.on("open", () => el.classList.add("map-marker--active"))
      popup.on("close", () => el.classList.remove("map-marker--active"))

      new mapboxgl.Marker(el)
        .setLngLat([stop.lng, stop.lat])
        .setPopup(popup)
        .addTo(this.map)

      bounds.extend([stop.lng, stop.lat])
    })

    if (this.stopsValue.length > 1) {
      this.map.addSource("route", {
        type: "geojson",
        data: {
          type: "Feature",
          geometry: {
            type: "LineString",
            coordinates: this.stopsValue.map((stop) => [stop.lng, stop.lat])
          }
        }
      })

      this.map.addLayer({
        id: "route",
        type: "line",
        source: "route",
        layout: { "line-join": "round", "line-cap": "round" },
        paint: { "line-color": "#7B8FF5", "line-width": 3, "line-dasharray": [2, 2] }
      })

      this.map.fitBounds(bounds, { padding: 48 })
    }
  }
}
