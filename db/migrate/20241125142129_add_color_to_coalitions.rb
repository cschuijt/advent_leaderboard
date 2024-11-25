class AddColorToCoalitions < ActiveRecord::Migration[7.1]
  def change
    add_column :coalitions, :color, :string
  end
end
