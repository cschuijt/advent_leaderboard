class Year < ApplicationRecord
  has_many :days
  has_many :participants

  has_many :stars, through: :days
  has_many :users, through: :participants

  validates :number, presence: true, uniqueness: true
end
