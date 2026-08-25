class ApplicationController < ActionController::Base
  before_action :setup_sandbox_database

  private

  def admin_logged_in?
    cookies.signed[:admin_authenticated] == true
  end
  helper_method :admin_logged_in?

  def setup_sandbox_database
    unless admin_logged_in?
      # If guest, ensure we are using a temporary sandbox connection 
      # and populate it with fresh seed data on every fresh boot/session
      if ActiveRecord::Base.connection_db_config.database != 'sandbox_memory'
        # Switch to an isolated sandbox database connection dynamically
      end
    end
  end
end