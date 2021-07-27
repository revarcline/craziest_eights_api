class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.boolean :is_ai
      t.table :belongs_to

      t.timestamps
    end
  end
end
