class AddArchivedToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_column :recipes, :archived, :boolean, default: false
  end
end