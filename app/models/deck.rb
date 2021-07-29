class Deck < ApplicationRecord
  belongs_to :game
  has_many :cards, dependent: :destroy
  has_many :piles, dependent: :destroy

  after_create :build_deck

  private

  def build_deck
    stock = Pile.create(deck: self, role: 'stock')
    discard = Pile.create(deck: self, role: 'discard')
    build_cards(stock)
    stock.shuffle
    stock.move(stock.top_card, discard)
  end

  def build_cards(stock)
    suits = %w[S D C H]
    ranks = ('2'..'10').to_a + %w[J Q K A]
    number.times do
      suits.each do |suit|
        ranks.each do |rank|
          Card.create(rank: rank, suit: suit, deck: self, pile: stock)
        end
      end
    end
  end
end
