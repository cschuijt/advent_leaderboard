class OpenDayJob < ApplicationJob
  queue_as :default

  def perform(year, day)
    day = Year.find_by!(number: year).days.find_by!(number: day)

    day.update!(open: true)
  end
end
