class CreateStars < ActiveRecord::Migration[7.1]
  def change
    create_table :stars do |t|
      t.bigint :day_id
      t.bigint :participant_id
      t.integer :index
      t.datetime :completed_at

      t.timestamps
    end
  end
end
