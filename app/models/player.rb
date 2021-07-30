class Player < ApplicationRecord
  belongs_to :game
  has_one :pile
  has_many :cards, through: :pile
  validate :can_only_join_pending, :max_eight_per_game

  def ai_move
    # latency for realism
    sleep(2.5)
    # check game.open_card against hand for valid_move?
    # if no matches, draw, then check drawn card for valid_move?
    move = cards.find { |card| valid_move?(card) }
    if move
      play_card(move)
    else
      draw_til_valid
    end
  end

  def play_card(card)
    return false unless valid_move?(card)

    pile.move(card, game.discard)
    game.check_turn
    true
  end

  def valid_move?(card)
    card.matches?(game.open_card) && card.in?(hand)
  end

  def draw_from_stock
    new_card = game.stock.top_card
    pile.move(new_card, pile)
    game.discard_to_stock if game.stock.cards.empty?
    new_card
  end

  def hand_size
    cards.count
  end

  def hand
    pile.ordered_cards
  end

  def won?
    # return game winner id if exists or false (based on hand size)
    game.winner || hand_size.zero?
  end

  private

  def can_only_join_pending
    errors.add(:game, 'can only join a pending game') unless game.state == 'pending'
  end

  def max_eight_per_game
    errors.add(:game, 'maximum of eight players per game') unless game.player_count < 8
  end

  def draw_til_valid
    card = draw_from_stock
    if valid_move?(card)
      play_card(card)
    else
      draw_til_valid
    end
  end
end
