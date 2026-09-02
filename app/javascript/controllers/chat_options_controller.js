import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "travelerCounter",
    "travelerCount"
  ]

  connect() {
    this.selectedValues = []
    this.travelerCount = 4
  }

  selectTraveler(event) {
    const button = event.currentTarget
    const value = Number(button.dataset.value)

    this.clearSelectedOptions()
    button.classList.add("chat-option--selected")

    if (value === 4) {
      this.travelerCount = 4
      this.travelerCountTarget.textContent = this.travelerCount
      this.travelerCounterTarget.hidden = false
      return
    }

    this.submitValue(value.toString())
  }

  increaseTraveler() {
    this.travelerCount += 1
    this.travelerCountTarget.textContent = this.travelerCount
  }

  decreaseTraveler() {
    if (this.travelerCount <= 4) return

    this.travelerCount -= 1
    this.travelerCountTarget.textContent = this.travelerCount
  }

  submitTraveler() {
    this.submitValue(this.travelerCount.toString())
  }

  selectSingle(event) {
    const button = event.currentTarget

    this.clearSelectedOptions()
    button.classList.add("chat-option--selected")

    this.submitValue(button.dataset.value)
  }

  toggleMulti(event) {
    const button = event.currentTarget
    const value = button.dataset.value

    button.classList.toggle("chat-option--selected")

    if (button.classList.contains("chat-option--selected")) {
      if (!this.selectedValues.includes(value)) {
        this.selectedValues.push(value)
      }
    } else {
      this.selectedValues = this.selectedValues.filter(
        selectedValue => selectedValue !== value
      )
    }
  }

  submitMulti() {
    if (this.selectedValues.length === 0) return

    this.submitValue(this.selectedValues.join(", "))
  }

  submitValue(value) {
    const form = document.querySelector(".message-form")

    if (!form) return

    const input = form.querySelector(".message-input")

    if (!input) return

    input.value = value
    form.requestSubmit()
  }

  clearSelectedOptions() {
    this.element.querySelectorAll(".chat-option").forEach((button) => {
      button.classList.remove("chat-option--selected")
    })
  }
}
