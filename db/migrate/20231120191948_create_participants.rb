class CreateParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :participants do |t|
      t.bigint :year_id
      t.bigint :user_id
      t.integer :score

      t.timestamps
    end
  end
end
