class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :rank
      t.string :suit
      t.references :deck, null: false, foreign_key: true
      t.references :pile, foreign_key: true

      t.timestamps
    end
  end
end
