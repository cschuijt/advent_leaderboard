class Year < ApplicationRecord
  has_many :days

  validates :number, presence: true, uniqueness: true
end
