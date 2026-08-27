class ProfilePolicy < ApplicationPolicy
  def show?
    record == user
  end

  def edit?
    record == user
  end

  def update?
    record == user
  end

  def destroy?
    record == user
  end
end
