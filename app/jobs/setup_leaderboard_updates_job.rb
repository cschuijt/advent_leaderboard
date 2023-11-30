class SetupLeaderboardUpdatesJob < ApplicationJob
  def perform(year, days = 25, min_interval = 20)
    GoodJob::Bulk.enqueue do
      # We start running at 5AM UTC on December 1st and end after the given
      # amount of days. For each minute interval given, we will enqueue a job
      # to update this leaderboard, as far as those times are in the future.
      start_time = DateTime.new(year, 12, 1, 5, 0)
      end_time   = start_time + days.days

      time = start_time
      while time <= end_time
        # We do not need to enqueue jobs that are in the past
        if time > Time.now
          UpdateLeaderboardJob.set(wait_until: time).perform_later(year)
        end

        time = time + min_interval.minutes
      end
    end
  end
end
