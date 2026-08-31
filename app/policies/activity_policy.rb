# frozen_string_literal: true

class ActivityPolicy < ApplicationPolicy
  def show?
    owner?
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def new?
    owner?
  end

  def create?
    owner?
  end

  class Scope < ApplicationPolicy::Scope
  end

  private

  def owner?
    record.trip_day.trip.user == user
  end
end
