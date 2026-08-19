import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = [ "beanList", "recipeGrid", "dropdownMenu", "contextActions", "backdrop" ]

  connect() {
    this.beanSortable = Sortable.create(this.beanListTarget, {
      handle: ".drag-handle",
      animation: 150,
      disabled: true,
      ghostClass: "sortable-ghost",
      dragClass: "sortable-drag",
      onStart: () => document.body.classList.add("is-dragging"),
      onEnd: () => document.body.classList.remove("is-dragging")
    })

    this.recipeSortables = this.recipeGridTargets.map(grid => {
      return Sortable.create(grid, {
        handle: ".recipe-sort-overlay",
        animation: 150,
        disabled: true,
        ghostClass: "sortable-ghost",
        dragClass: "sortable-drag",
        onStart: () => document.body.classList.add("is-dragging"),
        onEnd: () => document.body.classList.remove("is-dragging")
      })
    })

    this.initialBeanOrder = []
    this.initialRecipeOrders = new Map()
  }

  enableSortMode() {
    document.body.classList.remove("mode-delete")
    document.body.classList.add("mode-sort")

    this.beanSortable.option("disabled", false)
    this.recipeSortables.forEach(s => s.option("disabled", false))

    // Snapshot DOM order for Cancel action
    this.initialBeanOrder = Array.from(this.beanListTarget.children)
    this.initialRecipeOrders.clear()
    this.recipeGridTargets.forEach(grid => {
      this.initialRecipeOrders.set(grid, Array.from(grid.children))
    })

    this.showContextActions()
    this.closeDropdown()
  }

  enableDeleteMode() {
    document.body.classList.remove("mode-sort")
    document.body.classList.add("mode-delete")

    this.beanSortable.option("disabled", true)
    this.recipeSortables.forEach(s => s.option("disabled", true))

    this.showContextActions()
    this.closeDropdown()
  }

  cancelMode() {
    if (document.body.classList.contains("mode-sort")) {
      // Restore Bean order
      this.initialBeanOrder.forEach(el => this.beanListTarget.appendChild(el))
      // Restore Recipe order per grid
      this.initialRecipeOrders.forEach((children, grid) => {
        children.forEach(el => grid.appendChild(el))
      })
    }
    this.resetMode()
  }

  doneMode() {
    if (document.body.classList.contains("mode-sort")) {
      this.saveBeanSort()
      this.saveRecipeSort()
    }
    this.resetMode()
  }

  resetMode() {
    document.body.classList.remove("mode-sort", "mode-delete")
    this.beanSortable.option("disabled", true)
    this.recipeSortables.forEach(s => s.option("disabled", true))
    this.hideContextActions()
    this.closeDropdown()
  }

  saveBeanSort() {
    let beanIds = Array.from(this.beanListTarget.children).map(el => el.dataset.id).filter(Boolean)
    if (beanIds.length === 0) return

    fetch("/beans/sort", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ bean_ids: beanIds })
    })
  }

  saveRecipeSort() {
    this.recipeGridTargets.forEach(grid => {
      let recipeIds = Array.from(grid.children).map(el => el.dataset.id).filter(Boolean)
      if (recipeIds.length === 0) return

      fetch("/recipes/sort", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ recipe_ids: recipeIds })
      })
    })
  }

  // Dropdown helpers
  toggleDropdown() {
    this.dropdownMenuTarget.classList.contains("hidden") ? this.openDropdown() : this.closeDropdown()
  }

  openDropdown() {
    this.dropdownMenuTarget.classList.remove("hidden")
    if (this.hasBackdropTarget) this.backdropTarget.classList.remove("hidden")
  }

  closeDropdown() {
    this.dropdownMenuTarget.classList.add("hidden")
    if (this.hasBackdropTarget) this.backdropTarget.classList.add("hidden")
  }

  showContextActions() { this.contextActionsTarget.classList.remove("hidden") }
  hideContextActions() { this.contextActionsTarget.classList.add("hidden") }
}