class CreatePiles < ActiveRecord::Migration[6.1]
  def change
    create_table :piles do |t|
      t.string :role
      t.int :order
      t.deck :belongs_to
      t.player :belongs_to

      t.timestamps
    end
  end
end
