class Pile < ApplicationRecord
  belongs_to :deck
  belongs_to :player
  has_many :cards

  def shuffle
    card_ids = cards(&:id)

  end
end
