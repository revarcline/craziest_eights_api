class Player < ApplicationRecord
  belongs_to :game
  has_one :pile
  has_many :cards, through: :pile
  validate :can_only_join_pending, :max_eight_per_game

  def ai_move
    # ai brain
  end

  def play_card(card)
    pile.move(card, game.discard) if valid_move?(card)
  end

  def valid_move?(card)
    card.matches?(game.discard.bottom_card)
  end

  def draw_from_stock
    pile.move(game.stock.top_card, pile)
  end

  def hand_size
    cards.count
  end

  private

  def can_only_join_pending
    errors.add(:game, 'can only join a pending game') unless game.state == 'pending'
  end

  def max_eight_per_game
    errors.add(:game, 'maximum of eight players per game') unless game.player_count < 8
  end
end
