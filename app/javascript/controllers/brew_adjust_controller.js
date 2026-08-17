import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "doseInput", "grindInput", "doseBtn", "grindBtn" ]
  static values = { baseDose: Number, baseGrind: Number }

  connect() {
    // On load, select the [OK] buttons (which represent an adjustment of 0)
    this.updateDoseUI(0)
    this.updateGrindUI(0)
  }

  // --- DOSE ACTIONS ---
  selectDose(event) {
    event.preventDefault()
    // Calculate new dose based on button clicked
    const amount = parseFloat(event.currentTarget.dataset.amount)
    this.doseInputTarget.value = (this.baseDoseValue + amount).toFixed(1)
    
    // Update the colors
    this.updateDoseUI(amount)
    this.doseInputTarget.style.backgroundColor = ""
  }

  manualDose() {
    const current = parseFloat(this.doseInputTarget.value)
    const diff = current - this.baseDoseValue
    let matched = false

    // Check if what you typed matches one of our preset buttons
    this.doseBtnTargets.forEach(btn => {
      const btnAmount = parseFloat(btn.dataset.amount)
      if (Math.abs(diff - btnAmount) < 0.01) {
        btn.style.backgroundColor = "lightgreen"
        matched = true
      } else {
        btn.style.backgroundColor = ""
      }
    })

    // If it's a completely custom number, highlight the input box green
    if (!matched && current !== this.baseDoseValue) {
      this.doseInputTarget.style.backgroundColor = "lightgreen"
    } else {
      this.doseInputTarget.style.backgroundColor = ""
    }
  }

  updateDoseUI(selectedAmount) {
    this.doseBtnTargets.forEach(btn => {
      const btnAmount = parseFloat(btn.dataset.amount)
      if (btnAmount === selectedAmount) {
        btn.style.backgroundColor = "lightgreen"
      } else {
        btn.style.backgroundColor = ""
      }
    })
  }


  // --- GRIND ACTIONS ---
  selectGrind(event) {
    event.preventDefault()
    const amount = parseFloat(event.currentTarget.dataset.amount)
    this.grindInputTarget.value = (this.baseGrindValue + amount).toFixed(1)
    
    this.updateGrindUI(amount)
    this.grindInputTarget.style.backgroundColor = ""
  }

  manualGrind() {
    const current = parseFloat(this.grindInputTarget.value)
    const diff = current - this.baseGrindValue
    let matched = false

    this.grindBtnTargets.forEach(btn => {
      const btnAmount = parseFloat(btn.dataset.amount)
      if (Math.abs(diff - btnAmount) < 0.01) {
        btn.style.backgroundColor = "lightgreen"
        matched = true
      } else {
        btn.style.backgroundColor = ""
      }
    })

    if (!matched && current !== this.baseGrindValue) {
      this.grindInputTarget.style.backgroundColor = "lightgreen"
    } else {
      this.grindInputTarget.style.backgroundColor = ""
    }
  }

  updateGrindUI(selectedAmount) {
    this.grindBtnTargets.forEach(btn => {
      const btnAmount = parseFloat(btn.dataset.amount)
      if (btnAmount === selectedAmount) {
        btn.style.backgroundColor = "lightgreen"
      } else {
        btn.style.backgroundColor = ""
      }
    })
  }
}