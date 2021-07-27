class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :tables do |t|
      t.string :name
      t.int :turn
      t.string :state

      t.timestamps
    end
  end
end
