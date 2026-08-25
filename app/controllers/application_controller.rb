class ApplicationController < ActionController::Base
  before_action :switch_database

  private

  def admin_logged_in?
    cookies.signed[:admin_authenticated] == true
  end
  helper_method :admin_logged_in?

  def switch_database
    if admin_logged_in?
      # Persistent admin database file
      db_path = Rails.root.join("db", "admin_#{Rails.env}.sqlite3")
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: db_path)
    else
      # In-memory sandbox for guests
      current_config = ActiveRecord::Base.connection_db_config.configuration_hash[:database]
      
      if current_config != ":memory:"
        ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
        
        # Load the database schema tables into RAM first
        load(Rails.root.join("db", "schema.rb"))
        
        # Then populate with your seed data
        Rails.application.load_seed
      end
    end
  end
end