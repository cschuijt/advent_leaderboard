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

  extend FortytwoIntra

  # Instantiates a new user from data we get out of the 42 API for
  # a specific username. This user will not be saved to the database
  # yet, so we can add their AoC ID to it beforehand.
  def self.from_42_api(username)
    api_response = fortytwo_api_client.get("/v2/users/#{username}")

    return User.new(
      username: api_response.login,
      full_name: api_response.usual_full_name,
      photo_url: api_response.image.versions.medium
    )
  end

  private

  def remove_hashtags
    aoc_user_id.remove!("#") if aoc_user_id
  end
end
