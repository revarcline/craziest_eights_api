class CreatePiles < ActiveRecord::Migration[6.1]
  def change
    create_table :piles do |t|
      t.string :role
      t.references :deck, null: false, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
