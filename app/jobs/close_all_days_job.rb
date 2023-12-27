class CloseAllDaysJob < ApplicationJob
  queue_as :default

  def perform(year_no)
    ActiveRecord::Base.transaction do
      year = Year.find_by!(number: year_no)
      year.update!(finished: true)
      year.days.where(open: true).each do |day|
        day.update!(open: false)
      end
    end
  end
end
