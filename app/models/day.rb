class Day < ApplicationRecord
  belongs_to :year

  validates :number, presence: true, uniqueness: { scope: :year }
end
