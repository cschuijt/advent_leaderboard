class Participant < ApplicationRecord
  belongs_to :year
  belongs_to :user

  has_many :stars

  validates :year, uniqueness: { scope: :user }
end
