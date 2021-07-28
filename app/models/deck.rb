class Deck < ApplicationRecord
  belongs_to :game
  has_many :cards, dependent: :destroy
  has_many :piles, dependent: :destroy

  after_create :build_cards

  private

  def build_cards
    suits = %w[S D C H]
    ranks = ('2'..'10').to_a + %w[J Q K A]
    stock = Pile.create(deck: self, role: 'stock')
    number.times do
      suits.each do |suit|
        ranks.each do |rank|
          Card.create(rank: rank, suit: suit, deck: self, pile: stock)
        end
      end
    end
    stock.shuffle
  end
end
