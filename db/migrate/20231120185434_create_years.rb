class CreateYears < ActiveRecord::Migration[7.1]
  def change
    create_table :years do |t|
      t.integer :number, null: :false

      t.timestamps
    end

    add_index :years, :number, unique: true
  end
end
