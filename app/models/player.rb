class Player < ApplicationRecord
  belongs_to :game
  has_one :pile
  has_many :cards, through: :pile

  def ai_move; end

  def play_card(card)
    pile.move(card, game.discard) if valid_move?(card)
  end

  def valid_move?(card)
    card.matches?(game.discard.bottom_card)
  end

  def draw_from_stock
    pile.move(game.stock.top_card, pile)
  end
end
