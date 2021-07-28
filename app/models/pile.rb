class Pile < ApplicationRecord
  belongs_to :deck
  belongs_to :player
end
