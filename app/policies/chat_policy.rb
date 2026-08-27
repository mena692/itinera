# app/policies/chat_policy.rb

class ChatPolicy < ApplicationPolicy
  def show?
    record.user == user
  end
end
