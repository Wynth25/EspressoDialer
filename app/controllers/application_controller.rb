class ApplicationController < ActionController::Base
  around_action :switch_database

  private

  def switch_database(&block)
    # Routes to PostgreSQL (:writing) if logged in, SQLite (:sandbox) otherwise
    role = session[:admin_id].present? ? :writing : :sandbox

    ActiveRecord::Base.connected_to(role: role, &block)
  end
end 