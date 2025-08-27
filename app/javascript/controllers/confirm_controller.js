import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { message: String }

  confirm(e) {
    const msg = this.messageValue || "are u sure?"
    if (!window.confirm(msg)) e.preventDefault()
  }
}
