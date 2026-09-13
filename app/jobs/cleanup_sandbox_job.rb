class CleanupSandboxJob < ApplicationJob
  queue_as :default

  def perform(token)
    return if token.blank?
    
    # .unscoped bypasses the default_scope so the job can find and delete the data
    Bean.unscoped.where(guest_token: token).destroy_all
    Basket.unscoped.where(guest_token: token).destroy_all
    Recipe.unscoped.where(guest_token: token).destroy_all
    Brew.unscoped.where(guest_token: token).destroy_all
  end
end