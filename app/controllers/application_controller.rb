class ApplicationController < ActionController::Base
  before_action :set_sandbox_session

  private

  def admin_logged_in?
    session[:admin_id] == "admin_authorized" 
  end

  helper_method :admin_logged_in?

  def set_sandbox_session
    if admin_logged_in?
      Current.guest_token = nil
    else
      unless cookies[:guest_token]
        token = SecureRandom.uuid
        cookies[:guest_token] = { value: token, expires: 1.day.from_now }
        
        # Set it immediately so the seeder uses the token
        Current.guest_token = token
        SandboxSeeder.seed
        
        CleanupSandboxJob.set(wait: 1.hour).perform_later(token)
      end
      
      Current.guest_token ||= cookies[:guest_token]
    end
  end
end