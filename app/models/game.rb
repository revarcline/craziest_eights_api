class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_many :piles, through: :deck

  accepts_nested_attributes_for :players

  def add_player(name, is_ai)
    Player.create(name: name, game: self, is_ai: is_ai)
  end

  def current_player
    players[turn % player_count]
  end

  def stock
    piles.find_by(role: 'stock')
  end

  def discard
    piles.find_by(role: 'discard')
  end

  def player_count
    players.count
  end

  def turn_player_id
    current_player.id
  end

  def open_card
    discard.bottom_card
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

  def check_turn
    if current_player.won?
      finish_game
    else
      increment_turn
      current_player.ai_move if current_player.is_ai?
    end
  end

  private

  def deal
    players.each do |player|
      Pile.create(deck: deck, player: player, role: 'hand')
    end
    5.times { players.each(&:draw_from_stock) }
  end

  def increment_turn
    update(turn: turn + 1)
  end

  def make_deck
    number = (player_count / 4) + 1
    Deck.create(game: self, number: number)
  end

  def finish_game
    update(state: 'complete')
  end
end
