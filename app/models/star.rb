class Star < ApplicationRecord
  belongs_to :day
  belongs_to :participant

  has_one :year, through: :day
  has_one :user, through: :participant

  validates :index, presence: true, uniqueness: { scope: [:day, :participant] }
end
