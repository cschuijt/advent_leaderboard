class User < ApplicationRecord
  has_many :participations, class_name: 'Participant'
  has_many :years, through: :participations
  has_many :stars, through: :participations

  validates :aoc_user_id, format: {
                            with: /\A\d+\z/, message: 'Only digits (0-9) allowed'
                          },
                          uniqueness: true,
                          allow_nil: true
  validates :intra_username, presence: true, uniqueness: true

end
