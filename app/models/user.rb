class User < ApplicationRecord
  validates :aoc_user_id, format: {
                            with: /\A\d+\z/, message: "Only digits (0-9) allowed"
                          },
                          uniqueness: true,
                          allow_nil: true
  validates :intra_username, presence: true, uniqueness: true

end
