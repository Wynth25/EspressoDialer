import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = [ "beanList", "dropdownMenu", "contextActions", "menuToggle", "backdrop" ]

  connect() {
    this.sortable = Sortable.create(this.beanListTarget, {
      handle: ".drag-handle",
      animation: 150,
      disabled: true
    })
    this.initialOrder = []
  }

  toggleDropdown() {
    if (this.dropdownMenuTarget.classList.contains("hidden")) {
      this.openDropdown()
    } else {
      this.closeDropdown()
    }
  }

  openDropdown() {
    this.dropdownMenuTarget.classList.remove("hidden")
    if (this.hasBackdropTarget) {
      this.backdropTarget.classList.remove("hidden")
    }
  }

  closeDropdown() {
    this.dropdownMenuTarget.classList.add("hidden")
    if (this.hasBackdropTarget) {
      this.backdropTarget.classList.add("hidden")
    }
  }

  enableSortMode() {
    document.body.classList.remove("mode-delete")
    document.body.classList.add("mode-sort")
    this.sortable.option("disabled", false)
    
    this.initialOrder = Array.from(this.beanListTarget.children)
    
    this.showContextActions()
    this.closeDropdown()
  }

  enableDeleteMode() {
    document.body.classList.remove("mode-sort")
    document.body.classList.add("mode-delete")
    this.sortable.option("disabled", true)
    
    this.showContextActions()
    this.closeDropdown()
  }

  showContextActions() {
    this.contextActionsTarget.classList.remove("hidden")
  }

  hideContextActions() {
    this.contextActionsTarget.classList.add("hidden")
  }

  cancelMode() {
    if (document.body.classList.contains("mode-sort")) {
      this.initialOrder.forEach(el => this.beanListTarget.appendChild(el))
    }
    this.resetMode()
  }

  doneMode() {
    if (document.body.classList.contains("mode-sort")) {
      this.saveSort()
    }
    this.resetMode()
  }

  resetMode() {
    document.body.classList.remove("mode-sort", "mode-delete")
    this.sortable.option("disabled", true)
    this.hideContextActions()
    this.closeDropdown()
  }

  saveSort() {
    let beanIds = Array.from(this.beanListTarget.children).map(el => el.dataset.id).filter(id => id)
    if (beanIds.length === 0) return;

    fetch("/beans/sort", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ bean_ids: beanIds })
    })
  }
}