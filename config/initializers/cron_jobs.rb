Rails.application.configure do
  # There are two different kinds of background job: a job that runs every
  # 20 minutes to update our version of the leaderboard throughout December,
  # and a one-time job for November 20th to set up the new year's leaderboard.
  # During the month, days are also opened so the layout knows which day is
  # the currently active one. At the end of the month, a job runs to close
  # all of them again.
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
    },
    open_next_day: {
      # Run at 5:01AM UTC because that is one minute after the new puzzle opens,
      # after December 25th there is no need to run this anymore.
      cron: "1 5 1-25 DEC *",
      class: "OpenNextDayJob",
      # This needs to be a proc, else the year and day
      # will not update dynamically.
      kwargs: -> { { year: Time.now.year, day: Time.now.day } },
      description: "Sets the new day to open in the database"
    },
    close_all_days: {
      # Run one minute after new year and ends the past year's event
      cron: "1 0 1 JAN *",
      class: "CloseAllDaysJob",
      kwargs: -> { { year: Time.now.year - 1 } },
      description: "End the event by closing all open days"
    }
  }
end
