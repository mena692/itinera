// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "controllers"

Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.getAttribute("url"))
}

ActiveStorage.start()
import "@popperjs/core"
import "bootstrap"
