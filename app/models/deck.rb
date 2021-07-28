class Deck < ApplicationRecord
  belongs_to :game
  has_many :cards, dependent: :destroy
  has_many :piles, dependent: :destroy

  private

  def build_cards
    suits = %w[S D C H]
    ranks = ('2'..'10').to_a + %w[J Q K A]
    number.times do
      suits.each do |suit|
        ranks.each do |rank|
          Card.create(rank: rank, suit: suit, deck: self)
        end
      end
    end
  end
end
