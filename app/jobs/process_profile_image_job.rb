class ProcessProfileImageJob < ApplicationJob
  queue_as :default

  def perform(user)
    return unless user.photo.attached?

    user.photo.variant(resize_to_limit: [500, 500]).processed
  end
end
