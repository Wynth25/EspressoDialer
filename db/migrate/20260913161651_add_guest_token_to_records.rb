class AddGuestTokenToRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :beans, :guest_token, :string
    add_column :recipes, :guest_token, :string
    add_column :baskets, :guest_token, :string
    add_column :brews, :guest_token, :string
    
    # Indexes make scoping queries lightning fast
    add_index :beans, :guest_token
    add_index :recipes, :guest_token
    add_index :baskets, :guest_token
    add_index :brews, :guest_token
  end
end