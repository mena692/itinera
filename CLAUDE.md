# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Itinera is a Rails 8.1 app for planning trips (a user creates `Trip`s, made of `TripDay`s, made of
`Activity` items; each `Trip` can have `Chat`s with `Message`s, presumably an AI trip-planning
assistant). Generated from the [lewagon/rails-templates](https://github.com/lewagon/rails-templates)
bootcamp template, so it includes Devise, Bootstrap 5, simple_form, and Pundit out of the box.

## Commands

- Setup: `bin/setup` (installs gems, prepares the DB, clears logs/tmp, then boots the server).
  Add `--reset` to reset the DB, `--skip-server` to skip booting the server.
- Run dev server: `bin/dev` (wraps `bin/rails server`).
- Run all tests: `bin/rails test`
- Run a single test file: `bin/rails test test/models/trip_test.rb`
- Run a single test: `bin/rails test test/models/trip_test.rb -n test_method_name`
- Lint: `bin/rubocop` (rubocop-rails-omakase config, see `.rubocop.yml` for the few overrides —
  notably `Layout/LineLength` max is 120)
- Security scans: `bin/bundler-audit`, `bin/importmap audit`, `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- Full CI suite (what CI runs, in order): `bin/ci` — see `config/ci.rb` for the exact steps
  (setup, rubocop, the three security scans above, `bin/rails test`, and
  `RAILS_ENV=test bin/rails db:seed:replant`)
- Deploy: `bin/kamal deploy` (see `config/deploy.yml` and `.kamal/`)

## Architecture

### Authorization: Pundit allow-list

`ApplicationController` (`app/controllers/application_controller.rb`) enforces Pundit on every
action by default via `after_action :verify_authorized` / `verify_policy_scoped`. This means:

- Any new controller action MUST call `authorize @record` (or `policy_scope` for `index`) or the
  request will raise `Pundit::NotAuthorizedError` in the `after_action` check.
- `skip_pundit?` exempts Devise controllers and `PagesController` from this requirement — extend
  that method (rather than adding ad-hoc `skip_after_action` calls) if another controller needs to
  opt out.
- Policies live in `app/policies/`; `ApplicationPolicy` denies everything by default (`index?`,
  `show?`, `create?`, `update?`, `destroy?` all return `false`), so every model needs an explicit
  policy once its controller is filled in.
- `rescue_from Pundit::NotAuthorizedError` is deliberately commented out in
  `ApplicationController` — uncomment only once you understand the implications (per the comment
  there).

### Controllers are stubs

`ActivitiesController`, `ChatsController`, `MessagesController`, `TripDaysController`, and
`TripsController` currently have empty bodies — routes/actions/views for these resources have not
been built yet. `config/routes.rb` only defines `devise_for :users` and `root to: "pages#home"`;
resourceful routes need to be added as these controllers are implemented.

### Auth: Devise with custom name fields

`User` uses Devise modules `:database_authenticatable, :registerable, :recoverable,
:rememberable, :validatable` (no `:confirmable`/`:lockable`/etc.). `first_name`/`last_name` are
custom fields permitted via `configure_permitted_parameters` in `ApplicationController` (Devise's
own controllers, not custom ones, since none have been generated) — extend the `keys:` array there
when adding new sign-up/account-update fields, and keep the corresponding Devise view partials
(`app/views/devise/**`) in sync.

### Data model

- `User has_many :trips, :chats`
- `Trip belongs_to :user`; `has_many :trip_days, :chats` (both `dependent: :destroy`)
- `TripDay belongs_to :trip`; `has_many :activities, dependent: :destroy`
- `Activity belongs_to :trip_day`
- `Chat belongs_to :user, :trip`; `has_many :messages, dependent: :destroy`
- `Message belongs_to :chat`

`db/seeds.rb` is currently a template with blank attribute assignments (`User.create!(email:
encrypted_password: ...)` etc.) — it will raise until filled in with real values; note `bin/ci`
runs `db:seed:replant` against the test DB as part of the suite.

### Frontend

Bootstrap 5 + Sprockets (not cssbundling/jsbundling), Importmap for JS, Stimulus/Turbo for
interactivity, simple_form for forms, font-awesome-sass for icons. SCSS is organized under
`app/assets/stylesheets/{components,config,pages}`; `config/_bootstrap_variables.scss` and
`config/_colors.scss` hold shared design tokens — override there rather than hardcoding values in
individual page/component partials.
