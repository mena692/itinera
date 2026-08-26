# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Itinera is a Rails 8.1 app for building trip itineraries with AI-assisted chat. It was bootstrapped from the [lewagon/rails-templates](https://github.com/lewagon/rails-templates) Devise template (Le Wagon bootcamp starter). Data model: a `User` has many `Trip`s; a `Trip` has many `TripDay`s and `Chat`s; a `TripDay` has many `Activity`s; a `Chat` has many `Message`s (presumably an AI assistant chat scoped to a trip).

## Commands

Database is PostgreSQL (`config/database.yml`); dev/test DBs are `itinera_development` / `itinera_test`.

- Setup: `bin/setup` (installs gems, prepares db, clears logs; add `--reset` to reset db, `--skip-server` to skip starting the server)
- Run dev server: `bin/dev` (wraps `bin/rails server`)
- Run all tests: `bin/rails test`
- Run a single test file: `bin/rails test test/models/trip_test.rb`
- Run a single test: `bin/rails test test/models/trip_test.rb -n test_the_truth` (or `bin/rails test test/models/trip_test.rb:LINE_NUMBER`)
- Lint (Rubocop, Omakase config): `bundle exec rubocop`
- Security scan (Brakeman): `bundle exec brakeman`
- Gem vulnerability audit: `bundle exec bundler-audit check`
- Console: `bin/rails console`
- Migrate: `bin/rails db:migrate`

Tests run in parallel across processors (`test/test_helper.rb`). The generator config (`config/application.rb`) disables fixtures (`fixture: false`), helpers, and assets on `bin/rails generate` — model/controller generators won't scaffold those files, and none of the controller/model test files currently use fixtures.

## Architecture

- **Models** (`app/models`): `Trip` → `TripDay` → `Activity` (nested itinerary structure, all `dependent: :destroy` down the chain), and `Trip` → `Chat` → `Message` (a chat thread attached to a trip, `dependent: :destroy`). `User` owns both `trips` and `chats` directly.
- **Auth**: Devise (`database_authenticatable, registerable, recoverable, rememberable, validatable`) on `User`. `ApplicationController` has a global `before_action :authenticate_user!`; controllers that need public access must `skip_before_action :authenticate_user!` explicitly (see `PagesController#home`).
- **Controllers/routes**: `ActivitiesController`, `ChatsController`, `MessagesController`, `TripDaysController`, `TripsController` exist as empty stubs — routes for them have not been added to `config/routes.rb` yet (only `devise_for :users` and `root to: "pages#home"` are defined). When implementing these resources, add the corresponding routes.
- **Frontend stack**: Propshaft asset pipeline, importmap-rails (no Node/webpack build step, no `package.json`), Hotwire (Turbo + Stimulus), Bootstrap 5 + `font-awesome-sass` + `autoprefixer-rails` via `sassc-rails`/Sprockets, forms via `simple_form` (Bootstrap-configured in `config/initializers/simple_form_bootstrap.rb`). Stylesheet entrypoint is `app/assets/stylesheets/application.scss`, importing `config/*` (fonts, colors, bootstrap variable overrides) then `components/*` and `pages/*` partials — add new component/page styles as partials under those directories and import them from the corresponding `_index.scss`.
- **Background jobs / cache / cable**: `solid_queue`, `solid_cache`, `solid_cable` (database-backed, no Redis dependency).
- **Deployment**: Dockerfile + Kamal (`config/deploy.yml`, `.kamal/`) for container-based deploys; Thruster in front of Puma in production.
