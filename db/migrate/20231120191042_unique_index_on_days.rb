class UniqueIndexOnDays < ActiveRecord::Migration[7.1]
  def change
    remove_index :days, [:year_id, :number]
    add_index    :days, [:year_id, :number], unique: true
  end
end
