class Deck < ApplicationRecord
  belongs_to :game
  has_many :cards, dependent: :destroy
  has_many :piles, dependent: :destroy
end
