import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("day-tabs controller connected")
    const activeTab = this.element.querySelector(".day-tab--active")
    if (activeTab) {
      activeTab.scrollIntoView({ behavior: "auto", block: "nearest", inline: "center" })
    }
  }
}
