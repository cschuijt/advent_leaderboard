class AddCoalitions < ActiveRecord::Migration[7.1]
  def change
    create_table :coalitions do |t|
      t.integer :fortytwo_id, null: false
      t.string  :name,        null: false
      t.string  :cover_url

      t.index :fortytwo_id, unique: true
    end

    add_column :users, :coalition_id, :integer
    add_index  :users, :coalition_id
  end
end
