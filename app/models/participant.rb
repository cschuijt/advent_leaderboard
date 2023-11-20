class Participant < ApplicationRecord
  belongs_to :year
  belongs_to :user

  validates :year, uniqueness: { scope: :user }
end
