class CloseAllDaysJob < ApplicationJob
  queue_as :default

  def perform(kwargs = {})
    ActiveRecord::Base.transaction do
      year = Year.find_by!(number: kwargs[:year])
      year.days.where(open: true).each do |day|
        day.update!(open: false)
      end
    end
  end
end
