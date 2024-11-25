class MakeUserCoalitionsUnique < ActiveRecord::Migration[7.1]
  def change
    add_index :coalitions_users, [:user_id, :coalition_id], unique: true
  end
end
