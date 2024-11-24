class Coalition < ApplicationRecord
  has_many :users, foreign_key: :fortytwo_id

  validates :fortytwo_id, presence: true,
                          uniqueness: true
end
