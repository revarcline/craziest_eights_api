class Card < ApplicationRecord
  belongs_to :deck
  belongs_to :pile

  def matches?(card)
    suit == card.suit ||
      rank == card.rank ||
      rank == '8'
  end
end
