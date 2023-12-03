class AddLastScoreboardPositionToParticipants < ActiveRecord::Migration[7.1]
  def change
    # Why were these still here
    remove_column :users, :fortytwo_api_token
    remove_column :users, :fortytwo_api_refresh_token
    remove_column :users, :fortytwo_api_expires_at

    add_column :participants, :position_yesterday, :integer
  end
end
