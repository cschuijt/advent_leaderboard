class SetupLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(year, days = 25, min_interval = 20)
    setup = AdventOfCode::Setup.new(year)
    setup.create_models(days)

    # To make sure you could call this retroactively on leaderboards that
    # have already been set up in the database, this job is extracted from
    # the main job. Call it separately if you do not want new database
    # models, just the update jobs.
    SetupLeaderboardUpdatesJob.perform_now(year, days, min_interval)
  end
end
