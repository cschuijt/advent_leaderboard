class User < ApplicationRecord
  has_many :participations, class_name: 'Participant', dependent: :destroy
  has_many :years, through: :participations
  has_many :stars, through: :participations

  validates :aoc_user_id, format: {
                            with: /\A\d+\z/, message: 'Only digits (0-9) allowed'
                          },
                          uniqueness: true,
                          allow_nil: true
  validates :username, presence: true, uniqueness: true

  before_validation :remove_hashtags

  private

  def remove_hashtags
    aoc_user_id.remove!("#") if aoc_user_id
  end
end
