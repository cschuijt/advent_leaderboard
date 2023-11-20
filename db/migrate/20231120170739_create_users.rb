class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :intra_username,     null: false
      t.string :intra_display_name, null: false
      t.string :photo_url
      t.string :aoc_user_id

      t.timestamps
    end

    add_index :users, :intra_username, unique: true
    add_index :users, :aoc_user_id,    unique: true
  end
end
