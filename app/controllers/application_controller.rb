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
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

      # If the table doesn't exist in this memory connection yet, load schema & seeds
      unless ActiveRecord::Base.connection.table_exists?(:beans)
        ActiveRecord::Schema.verbose = false
        schema_path = Rails.root.join("db", "schema.rb")
        load(schema_path) if File.exist?(schema_path)
        Rails.application.load_seed
      end
    end
  end
end