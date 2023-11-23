class OpenNextDayJob < ApplicationJob
  queue_as :default

  def perform(kwargs = {year: Time.now.year, day: Time.now.day})
    day = Year.find_by!(number: kwargs[:year]).days.find_by!(number: kwargs[:day])

    day.update!(open: true)
  end
end
