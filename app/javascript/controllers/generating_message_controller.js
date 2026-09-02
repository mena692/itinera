import { Controller } from "@hotwired/stimulus"

const MESSAGES = [
  "Queuing for the bus...",
  "Bribing the local pigeons for insider tips...",
  "Arguing with a map about which way is north...",
  "Making sure the museums haven't wandered off...",
  "Finding the nearest free toilet..."
]

const MIN_DELAY_MS = 2000
const MAX_DELAY_MS = 4000

export default class extends Controller {
  static targets = ["text"]

  connect() {
    this.index = 0
    this.textTarget.textContent = MESSAGES[this.index]
    this.scheduleNext()
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  scheduleNext() {
    const delay = MIN_DELAY_MS + Math.random() * (MAX_DELAY_MS - MIN_DELAY_MS)

    this.timeout = setTimeout(() => {
      this.index = (this.index + 1) % MESSAGES.length
      this.textTarget.textContent = MESSAGES[this.index]
      this.scheduleNext()
    }, delay)
  }
}
