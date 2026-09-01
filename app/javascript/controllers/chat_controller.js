import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.messages = this.element.querySelector(".chat-messages")

    this.scrollToBottom()

    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    this.observer.observe(this.messages, {
      childList: true,
      subtree: true
    })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  scrollToBottom() {
    this.messages.scrollTo({
      top: this.messages.scrollHeight,
      behavior: "smooth"
    })
  }
  preventBlank(event) {
    const input = event.target.querySelector(".message-input")

    if (input.value.trim() === "") {
      event.preventDefault()
      input.focus()
    }
  }
}
