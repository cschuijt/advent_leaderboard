class Star < ApplicationRecord
  belongs_to :day
  belongs_to :participant

  belongs_to :year, through: :day
  belongs_to :user, through: :participant

  validates :index, presence: true, uniqueness: { scope: [:day, :participant] }
end
