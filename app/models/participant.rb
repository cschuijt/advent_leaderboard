class Participant < ApplicationRecord
  belongs_to :year
  belongs_to :user

  has_many :stars

  default_scope { joins(:user) }

  delegate :username, :full_name, :photo_url, :aoc_user_id, to: :user

  validates :year, uniqueness: { scope: :user }
end
