class CreateDecks < ActiveRecord::Migration[6.1]
  def change
    create_table :decks do |t|
      t.integer :number
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
