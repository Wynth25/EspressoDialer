import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = [ "beanList", "recipeGrid", "dropdownMenu", "contextActions", "backdrop" ]

  connect() {
    // 1. Bean sorting (Only initialize if target exists)
    if (this.hasBeanListTarget) {
      this.beanSortable = Sortable.create(this.beanListTarget, {
        handle: ".drag-handle",
        animation: 150,
        disabled: true,
        ghostClass: "sortable-ghost",
        dragClass: "sortable-drag",
        onStart: () => document.body.classList.add("is-dragging"),
        onEnd: () => document.body.classList.remove("is-dragging")
      })
    }

    // 2. Recipe sorting per bean
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

    if (this.beanSortable) this.beanSortable.option("disabled", false)
    this.recipeSortables.forEach(s => s.option("disabled", false))

    // Snapshot DOM order for Cancel action
    if (this.hasBeanListTarget) {
      this.initialBeanOrder = Array.from(this.beanListTarget.children)
    }
    
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

    if (this.beanSortable) this.beanSortable.option("disabled", true)
    this.recipeSortables.forEach(s => s.option("disabled", true))

    this.showContextActions()
    this.closeDropdown()
  }

  cancelMode() {
    if (document.body.classList.contains("mode-sort")) {
      // Restore Bean order
      if (this.hasBeanListTarget) {
        this.initialBeanOrder.forEach(el => this.beanListTarget.appendChild(el))
      }
      // Restore Recipe order per grid
      this.initialRecipeOrders.forEach((children, grid) => {
        children.forEach(el => grid.appendChild(el))
      })
    }
    this.resetMode()
  }

  doneMode() {
    if (document.body.classList.contains("mode-sort")) {
      if (this.hasBeanListTarget) this.saveBeanSort()
      this.saveRecipeSort()
    }
    this.resetMode()
  }

  resetMode() {
    document.body.classList.remove("mode-sort", "mode-delete")
    if (this.beanSortable) this.beanSortable.option("disabled", true)
    this.recipeSortables.forEach(s => s.option("disabled", true))
    
    this.hideContextActions()
    this.closeDropdown()
  }

  saveBeanSort() {
    if (!this.hasBeanListTarget) return;
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

  // --- Dropdown Helpers ---

  toggleDropdown() {
    this.dropdownMenuTarget.classList.contains("hidden") ? this.openDropdown() : this.closeDropdown()
  }

  openDropdown() {
    document.querySelectorAll('.freeze-menu').forEach(m => m.classList.add('hidden'))
    this.dropdownMenuTarget.classList.remove("hidden")
    if (this.hasBackdropTarget) this.backdropTarget.classList.remove("hidden")
  }

  closeDropdown() {
    if (this.hasDropdownMenuTarget) this.dropdownMenuTarget.classList.add("hidden")
    if (this.hasBackdropTarget) this.backdropTarget.classList.add("hidden")
    document.querySelectorAll('.freeze-menu').forEach(m => m.classList.add('hidden'))
  }

  // --- Freeze Date Menus ---
  
  toggleFreezeMenu(event) {
    const menu = event.currentTarget.nextElementSibling;
    const isHidden = menu.classList.contains("hidden");

    if (this.hasDropdownMenuTarget) this.dropdownMenuTarget.classList.add("hidden");
    document.querySelectorAll('.freeze-menu').forEach(m => m.classList.add('hidden'));

    if (isHidden) {
      menu.classList.remove("hidden");
      if (this.hasBackdropTarget) this.backdropTarget.classList.remove("hidden");
    } else {
      menu.classList.add("hidden");
      if (this.hasBackdropTarget) this.backdropTarget.classList.add("hidden");
    }
  }

  // Catches form submissions to validate changes
  confirmFreezeChange(event) {
    const form = event.currentTarget;
    const isFrozen = form.dataset.frozen === "true";
    const originalDate = form.dataset.original;
    const roastDate = form.dataset.roast; 
    const input = form.querySelector('input[type="date"]');
    const newDate = input.value;

    // 1. PREVENT INVALID DATES
    if (newDate !== "" && roastDate && newDate < roastDate) {
      alert("The freeze date cannot be earlier than the roast date.");
      event.preventDefault(); // Stop form submission completely
      input.value = originalDate || ""; // Revert visually back to what it was
      return; 
    }

    // 2. CONFIRM CHANGES
    if (isFrozen && newDate !== originalDate) {
      const msg = newDate === "" 
        ? "Are you sure you want to clear the freeze date?" 
        : "Are you sure you want to change the freeze date?";

      if (!window.confirm(msg)) {
        event.preventDefault(); 
        input.value = originalDate || ""; 
      }
    }
  }

  // --- UI Action Helpers (These were missing!) ---
  
  showContextActions() {
    if (this.hasContextActionsTarget) {
      this.contextActionsTarget.classList.remove("hidden")
    }
  }

  hideContextActions() {
    if (this.hasContextActionsTarget) {
      this.contextActionsTarget.classList.add("hidden")
    }
  }
}