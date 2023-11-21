class Day < ApplicationRecord
  belongs_to :year
  has_many   :stars, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :year }
end
