class SetupLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    setup = AdventOfCode::Setup.new(options[:year])
    setup.create_models(options[:days])
  end
end
