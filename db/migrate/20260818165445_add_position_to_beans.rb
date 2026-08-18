class AddPositionToBeans < ActiveRecord::Migration[8.1]
  def change
    add_column :beans, :position, :integer
  end
end
