import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "doseSlider", "doseNumber", "basketSelect" ]

  updateNumber() {
    this.doseNumberTarget.value = this.doseSliderTarget.value
  }

  updateSlider() {
    this.doseSliderTarget.value = this.doseNumberTarget.value
  }

  updateBounds() {
    const selectedOption = this.basketSelectTarget.options[this.basketSelectTarget.selectedIndex]
    const min = selectedOption.dataset.min
    const max = selectedOption.dataset.max

    if (min && max) {
      // Update the physical limits of the slider
      this.doseSliderTarget.min = min
      this.doseSliderTarget.max = max
      
      // PRESERVE THE VALUE: 
      // Force the slider to try and match whatever is currently in the text box,
      // rather than overriding the text box to the middle of the new range.
      this.doseSliderTarget.value = this.doseNumberTarget.value
      
      // Unlock the inputs
      this.doseSliderTarget.disabled = false
      this.doseNumberTarget.disabled = false
    } else {
      // Lock them if they revert to "Select a Basket"
      this.doseSliderTarget.disabled = true
      this.doseNumberTarget.disabled = true
    }
  }
}