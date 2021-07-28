class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_many :piles, through: :deck
  attr_reader :stock, :discard

  def add_player(name, is_ai)
    Player.create(name: name, game: self, is_ai: is_ai) if state == 'pending' && player_count < 8
  end

  def current_player
    players[turn % player_count]
  end

  def player_count
    players.count
  end

  def turn_id
    current_player.id
  end

  def start_game
    make_deck
    deal
    update(state: 'active', turn: 0)
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

  def make_deck
    number = (player_count / 4) + 1
    Deck.create(game: self, number: number)
    @stock = piles.find_by(role: 'stock')
    @discard = piles.find_by(role: 'discard')
  end

  def play_game
    while state == 'active'
    end
  end

  def finish_game
    update(state: 'complete')
  end
end
