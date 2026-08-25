import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Start the timer to hide the message after 3 seconds (3000 milliseconds)
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    // Add the CSS class that triggers the fade-out animation
    this.element.classList.add("fade-out")
    
    // Wait for the animation to finish (400ms) before actually removing the element from the page
    setTimeout(() => {
      this.element.remove()
    }, 400)
  }
}