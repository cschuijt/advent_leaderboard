class SetupLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(options = {year: Time.now.year, days: 25, min_interval: 20})
    setup = AdventOfCode::Setup.new(options[:year])
    setup.create_models(options[:days])

    # To make sure you could call this retroactively on leaderboards that
    # have already been set up in the database, this job is extracted from
    # the main job. Call it separately if you do not want new database
    # models, just the update jobs.
    SetupLeaderboardUpdatesJob.perform_now(options)
  end
end
