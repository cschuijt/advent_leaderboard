class AddCoalitionUserJoinModel < ActiveRecord::Migration[7.1]
  def change
    create_table :coalitions_users do |t|
      t.belongs_to :coalition
      t.belongs_to :user
    end
  end
end
