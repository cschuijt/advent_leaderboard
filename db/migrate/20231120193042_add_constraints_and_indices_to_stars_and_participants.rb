class AddConstraintsAndIndicesToStarsAndParticipants < ActiveRecord::Migration[7.1]
  def change
    change_column :stars, :day_id, :bigint, null: false
    change_column :stars, :participant_id, :bigint, null: false
    change_column :stars, :index, :integer, null: :false, default: 1
    change_column :stars, :completed_at, :datetime, null: false

    add_index     :stars, [:participant_id, :index], unique: true
    add_index     :stars, [:day_id, :index]

    change_column :participants, :year_id, :bigint, null: false
    change_column :participants, :user_id, :bigint, null: false
    change_column :participants, :score, :integer, null: false, default: 0

    add_index :participants, [:year_id, :user_id], unique: true
    add_index :participants, [:year_id, :score]
  end
end
