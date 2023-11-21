class FixUniqueIndexOnStars < ActiveRecord::Migration[7.1]
  def change
    remove_index :stars, [:participant_id, :index]
    add_index    :stars, [:day_id, :index, :participant_id], unique: true
  end
end
