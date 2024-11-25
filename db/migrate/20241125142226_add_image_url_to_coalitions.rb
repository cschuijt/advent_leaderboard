class AddImageUrlToCoalitions < ActiveRecord::Migration[7.1]
  def change
    add_column :coalitions, :image_url, :string
  end
end
