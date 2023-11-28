class AddFinishedBooleanToYears < ActiveRecord::Migration[7.1]
  def change
    add_column :years, :finished, :boolean, null: false, default: false
  end
end
