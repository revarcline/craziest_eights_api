class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_many :piles, through: :deck
  attr_reader :total_players

  def add_player(name, is_ai)
    Player.create(name: name, game: self, is_ai: is_ai)
  end

  def start_game
    number = 2 if players.length > 4
    number |= 1
    Deck.create(game: self, number: number)
    deal
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

  def deal
    players.each do |player|
      Pile.create(deck: deck, player: player, role: 'hand')
    end
    5.times { players.each(&:draw_from_stock) }
  end
end
