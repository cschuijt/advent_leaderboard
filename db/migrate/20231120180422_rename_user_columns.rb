class RenameUserColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :intra_username, :username
    rename_column :users, :intra_display_name, :full_name
  end
end
