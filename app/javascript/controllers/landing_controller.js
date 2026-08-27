import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["splash", "content", "slide"]

  connect() {
    this.currentSlide = 0
    this.touchStartX = null

    setTimeout(() => {
      this.splashTarget.classList.add("d-none")
      this.contentTarget.classList.remove("d-none")
      this.showSlide()
    }, 1800)
  }

  touchStart(event) {
    if (event.target.closest("button")) {
      this.touchStartX = null
      return
    }

    this.touchStartX = event.changedTouches[0].screenX
  }

  touchEnd(event) {
    if (this.touchStartX === null) return

    const touchEndX = event.changedTouches[0].screenX
    const difference = this.touchStartX - touchEndX

    if (difference > 50) {
      this.next()
    }

    if (difference < -50) {
      this.previous()
    }

    this.touchStartX = null
  }

  next() {
    if (this.currentSlide < this.slideTargets.length - 1) {
      this.currentSlide += 1
      this.showSlide()
    }
  }

  previous() {
    if (this.currentSlide > 0) {
      this.currentSlide -= 1
      this.showSlide()
    }
  }

  goToSlide(event) {
    this.currentSlide = Number(event.currentTarget.dataset.slide)
    this.showSlide()
  }

  showSlide() {
    this.slideTargets.forEach((slide, index) => {
      slide.classList.toggle("d-none", index !== this.currentSlide)
    })
  }
}
