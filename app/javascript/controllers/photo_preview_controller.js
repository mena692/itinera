import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  preview() {
    const file = this.inputTarget.files[0]

    if (!file) return

    this.previewTarget.style.backgroundImage =
      `url(${URL.createObjectURL(file)})`

    this.previewTarget.querySelector(".add-photo")?.style.setProperty("display", "none")
  }
}
