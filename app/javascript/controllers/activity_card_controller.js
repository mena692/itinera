import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
 static targets = ["menu"]
 static values = { url: String }


 visit(event) {
   if (event.target.closest(".activity-card__actions") || event.target.closest(".activity-card__menu")) return


   Turbo.visit(this.urlValue)
 }


 toggleMenu(event) {
   event.preventDefault()
   event.stopPropagation()
   this.menuTarget.hidden = !this.menuTarget.hidden
 }


 closeMenu(event) {
   if (this.menuTarget.hidden) return
   if (this.element.contains(event.target)) return


   this.menuTarget.hidden = true
 }
}
