class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_one :deck
end
