class UpdateLeaderboardJob < ApplicationJob
  queue_as :default

  before_perform :check_if_stale_job

  def perform(year, options = {leaderboard_id: ENV['AOC_LEADERBOARD_ID'], cookie: ENV['AOC_LOGIN_TOKEN']})
    client = AdventOfCode::APIClient.new(
      year, options[:leaderboard_id], options[:cookie]
    )
    parser = AdventOfCode::Parser.new(client.leaderboard)
    parser.import
  end

  private

  def check_if_stale_job
    # If the server has been off for some time, we do not want to kill
    # Advent of Code with a million requests. Therefore, a safety is
    # built in to only execute these jobs if their time is set to less
    # than five minutes ago.
    throw :abort if scheduled_at && scheduled_at < Time.now - 5.minutes
  end
end
