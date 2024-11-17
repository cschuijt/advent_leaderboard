class SetupLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(year, days = 25, min_interval = 20)
    setup = AdventOfCode::Setup.new(year)
    setup.create_models(days)
  end
end
