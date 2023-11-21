Rails.application.configure do
  # There are two different kinds of background job: a job that runs every
  # 20 minutes to update our version of the leaderboard throughout December,
  # and a one-time job for November 20th to set up the new year's leaderboard.
  config.good_job.cron = {
    update_leaderboard: {
      cron: "*/20 * * DEC *",
      class: "UpdateLeaderboardJob",
      # This needs to be a proc, else it'll always use the year in which
      # the server was started
      kwargs: -> {
        {
          year:           Time.now.year,
          leaderboard_id: ENV["AOC_LEADERBOARD_ID"],
          cookie:         ENV["AOC_LOGIN_TOKEN"]
        }
      }
    },
    setup_new_leaderboard: {
      cron: "0 0 20 NOV *",
      class: "SetupLeaderboardJob",
      # This needs to be a proc, else it'll always use the year in which
      # the server was started
      kwargs: -> { { year: Time.now.year, days: 25 } },
      description: "Creates a new leaderboard for this year's Advent of Code"
    }
  }
end
