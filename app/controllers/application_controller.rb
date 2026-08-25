class ApplicationController < ActionController::Base
  around_action :switch_database

  # Expose this method to all ERB view templates
  helper_method :admin_logged_in?

  def admin_logged_in?
    session[:admin_id].present?
  end

  private

  def switch_database(&block)
    # Routes to PostgreSQL (:writing) if admin is logged in, SQLite (:sandbox) otherwise
    role = admin_logged_in? ? :writing : :sandbox

    ActiveRecord::Base.connected_to(role: role, &block)
  end
end