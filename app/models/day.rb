class Day < ApplicationRecord
  belongs_to :year
  has_many   :stars, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :year }

  def puzzle_url
    return "https://adventofcode.com/#{self.year.number}/day/#{self.number}"
  end

  def start_time
    return Time.utc(self.year.number, 12, self.number, 5)
  end

  def end_time
    return self.start_time + 1.day
  end
end
