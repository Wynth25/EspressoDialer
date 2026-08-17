class CreateBrews < ActiveRecord::Migration[8.1]
  def change
    create_table :brews do |t|
      t.references :recipe, null: false, foreign_key: true
      t.float :dose
      t.float :grind
      t.string :rating

      t.timestamps
    end
  end
end
