class Pile < ApplicationRecord
  belongs_to :deck
  belongs_to :player, optional: true
  has_many :cards

  def shuffle
    cards.pluck(:id).sort_by { rand }.each { |id| Card.find(id).touch }
  end

  def ordered_cards
    cards.order(updated_at: :desc)
  end

  def move(card, new_pile)
    card.update(pile: new_pile)
  end
end
