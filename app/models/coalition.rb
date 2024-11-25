class Coalition < ApplicationRecord
  has_many :users, foreign_key: :fortytwo_id
  has_and_belongs_to_many :users

  validates :fortytwo_id, presence: true,
                          uniqueness: true
end
