class Day < ApplicationRecord
  belongs_to :year
  has_many   :stars

  validates :number, presence: true, uniqueness: { scope: :year }
end
