class CreateDays < ActiveRecord::Migration[7.1]
  def change
    create_table :days do |t|
      t.integer :number,  null: :false
      t.boolean :visible, null: :false, default: :true
      t.boolean :open,    null: :false, default: :true
      t.bigint  :year_id, null: :false

      t.timestamps
    end

    add_index :days, [:year_id, :number]
  end
end
