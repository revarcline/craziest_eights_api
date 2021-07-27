class CreateDecks < ActiveRecord::Migration[6.1]
  def change
    create_table :decks do |t|
      t.int :number
      t.table :belongs_to

      t.timestamps
    end
  end
end
