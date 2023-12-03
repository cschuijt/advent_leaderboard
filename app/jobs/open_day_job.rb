class OpenDayJob < ApplicationJob
  queue_as :default

  def perform(year, day)
    year = Year.find_by!(number: year)
    day = year.days.find_by!(number: day)

    day.update!(open: true)

    year.participants.order(score: :desc).each.with_index do |p, i|
      p.update!(position_yesterday: i)
    end
  end
end
