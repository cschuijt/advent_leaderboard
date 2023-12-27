Rails.application.configure do
  # The job flow for the leaderboard is as follows:
  # - On November 20th, the leaderboard for that year will be set up.
  #   At this point, jobs will be enqueued to refresh it every 20 minutes.
  #   These jobs will not use cron, but will not be enqueued as far as they
  #   would end up in the past, so you can safely set up an older leaderboard,
  #   or the current leaderboard halfway through the month.
  # - Every day, the moment the current puzzle switches, a new day will
  #   be marked as active, telling the frontend which one to highlight.
  # - At the end of the month, all days will be marked as closed and the year
  #   will be marked as over, which will enable the frontend to show stats for
  #   the entire year when they are added.
  config.good_job.cron = {
    setup_new_leaderboard: {
      cron: "0 0 20 NOV *",
      class: "SetupLeaderboardJob",
      # This needs to be a proc, else it'll always use the year in which
      # the server was started
      args: -> { [Time.now.year, 25] },
      description: "Creates a new leaderboard for this year and schedules update jobs"
    },
    open_next_day: {
      # Run at 5:01AM UTC because that is one minute after the new puzzle opens,
      # after December 25th there is no need to run this anymore.
      cron: "1 5 1-25 DEC *",
      class: "OpenDayJob",
      # This needs to be a proc, else the year and day
      # will not update dynamically.
      args: -> { [Time.now.year, Time.now.day] },
      description: "Sets the new day to open in the database"
    },
    close_all_days: {
      # Run one minute after the event ends
      cron: "1 5 26 DEC *",
      class: "CloseAllDaysJob",
      args: -> { [Time.now.year] },
      description: "End the event by closing all open days"
    }
  }
end
