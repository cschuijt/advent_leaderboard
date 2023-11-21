class UpdateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    client = AdventOfCode::APIClient.new(
      options[:year], options[:leaderboard_id], options[:cookie]
    )
    parser = AdventOfCode::Parser.new(client.leaderboard)
    parser.import
  end
end
