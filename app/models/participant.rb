class Participant < ApplicationRecord
  belongs_to :year
  belongs_to :user

  has_many :stars, dependent: :destroy

  default_scope { joins(:user) }

  delegate :username, :full_name, :photo_url, :aoc_user_id, :intra_url, to: :user

  validates :user, uniqueness: { scope: :year }

  def gold_stars
    self.stars.where(index: 2)
  end

  def silver_stars
    self.stars.where(index: 1)
  end
end
