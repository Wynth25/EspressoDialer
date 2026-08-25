class ApplicationController < ActionController::Base
  before_action :setup_sandbox_or_admin

  private

  def admin_logged_in?
    cookies.signed[:admin_authenticated] == true
  end
  helper_method :admin_logged_in?

  def setup_sandbox_or_admin
    if admin_logged_in?
      # Your persistent, personal database for real data
      db_path = Rails.root.join("db", "admin_#{Rails.env}.sqlite3")
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: db_path)
    else
      # Pure RAM-based sandbox database for guests. 
      # Automatically wipes and re-seeds for every new session/visitor!
      if ActiveRecord::Base.connection_db_config.configuration_hash[:database] != ":memory:"
        ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
        load(Rails.root.join("db", "schema.rb"))
        Rails.application.load_seed
      end
    end
  end
end