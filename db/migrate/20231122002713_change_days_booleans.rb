class ChangeDaysBooleans < ActiveRecord::Migration[7.1]
  def change
    remove_column :days, :visible
    change_column :days, :open, :boolean, default: false, null: false
  end
end
