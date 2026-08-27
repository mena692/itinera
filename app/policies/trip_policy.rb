class TripPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def show?
    record.user == user
  end
end
