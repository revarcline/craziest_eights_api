class Player < ApplicationRecord
  belongs_to :game
  has_one :pile
  has_many :cards, through: :pile
end
