class AddArchivedAndFreezeDateToBeans < ActiveRecord::Migration[8.1]
  def change
    add_column :beans, :archived, :boolean
    add_column :beans, :freeze_date, :date
  end
end
