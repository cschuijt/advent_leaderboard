class Year < ApplicationRecord
  has_many :days,         dependent: :destroy
  has_many :participants, dependent: :destroy

  has_many :stars, through: :days
  has_many :users, through: :participants

  validates :number, presence: true, uniqueness: true
end
