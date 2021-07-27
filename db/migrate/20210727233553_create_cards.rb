class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.deck :belongs_to
      t.pile :belongs_to
      t.string :rank
      t.string :suit

      t.timestamps
    end
  end
end
