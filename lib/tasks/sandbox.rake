namespace :sandbox do
  desc "Resets the sandbox database with seed data"
  task reset: :environment do
    # 1. Switch to the sandbox database
    ActiveRecord::Base.connected_to(role: :sandbox) do
      # 2. Destroy all records
      Recipe.destroy_all 
      Brew.destroy_all
      Bean.destroy_all
      Basket.destroy_all
      
      # 3. Load your seed data
      load Rails.root.join('db', 'seeds.rb')
    end
    puts "Sandbox reset successfully."
  end
end