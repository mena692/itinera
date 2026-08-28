import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chip", "group"]

  connect() {
    this.show("future")
  }

  select(event) {
    this.show(event.currentTarget.dataset.status)
  }

  show(status) {
    this.chipTargets.forEach((chip) => {
      chip.classList.toggle("trip-filter-chip--active", chip.dataset.status === status)
    })

    this.groupTargets.forEach((group) => {
      group.hidden = group.dataset.status !== status
    })
  }
}
