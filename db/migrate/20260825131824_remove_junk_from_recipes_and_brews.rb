class RemoveJunkFromRecipesAndBrews < ActiveRecord::Migration[8.1]
  def change
    remove_column :recipes, :target_ratio, :string
    remove_column :brews, :rating, :string
  end
end