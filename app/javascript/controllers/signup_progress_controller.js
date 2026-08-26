import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "firstName",
    "lastName",
    "email",
    "password",
    "step"
  ]

  connect() {
    console.log("Signup progress controller connected")
    this.updateProgress()
  }

  updateProgress() {
    const step1 =
      this.firstNameTarget.value.trim() !== "" &&
      this.lastNameTarget.value.trim() !== ""

    const step2 =
      this.emailTarget.value.trim() !== ""

    const step3 =
      this.passwordTarget.value.length >= 8

    this.stepTargets[0].classList.toggle("active", step1)
    this.stepTargets[1].classList.toggle("active", step2)
    this.stepTargets[2].classList.toggle("active", step3)
  }
}
