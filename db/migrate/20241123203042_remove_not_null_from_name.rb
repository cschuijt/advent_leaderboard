class RemoveNotNullFromName < ActiveRecord::Migration[7.1]
  def change
    change_column :coalitions, :name, :string, null: true
  end
end
