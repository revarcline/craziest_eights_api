class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_many :piles, through: :deck

  def add_player(name, is_ai)
    Player.create(name: name, game: self, is_ai: is_ai)
  end

  def start_game
    number = 2 if players.length > 4
    Deck.create(game: self, number: number)
    update(state: 'active')
  end

  def stock
    piles.find_by(role: 'stock')
  end

  def discard
    piles.find_by(role: 'discard')
  end

  def discard_to_stock
    discard.shuffle_move(stock)
    stock.top_card.move(discard)
  end

  private

  def ai_move; end
end
