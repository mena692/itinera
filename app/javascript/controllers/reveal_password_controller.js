import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "toggle"]

  reveal() {
    if (this.inputTarget.type === "password") {
      this.inputTarget.type = "text"
      this.toggleTarget.textContent = "Hide"
    } else {
      this.inputTarget.type = "password"
      this.toggleTarget.textContent = "Show"
    }
  }
}
