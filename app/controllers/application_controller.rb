class ApplicationController < ActionController::Base
  before_action :switch_database

  private

  def admin_logged_in?
    cookies.signed[:admin_authenticated] == true
  end
  helper_method :admin_logged_in?

  def switch_database
    if admin_logged_in?
      # Points to your private, persistent admin database file
      db_path = Rails.root.join("db", "admin_#{Rails.env}.sqlite3")
    else
      # Points to the public sandbox database file
      db_path = Rails.root.join("db", "sandbox_#{Rails.env}.sqlite3")
      
      # If the sandbox file doesn't exist yet, automatically create and seed it
      unless File.exist?(db_path)
        ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: db_path)
        load(Rails.root.join("db", "schema.rb"))
        Rails.application.load_seed
      end
    end

    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: db_path)
  end
end