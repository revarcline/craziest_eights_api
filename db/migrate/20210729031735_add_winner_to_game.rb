class AddWinnerToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :winner, :integer
  end
end
