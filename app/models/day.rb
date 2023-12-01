class Day < ApplicationRecord
  belongs_to :year
  has_many   :stars, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :year }

  def puzzle_url
    return "https://adventofcode.com/#{self.year.number}/day/#{self.number}"
  end
end
