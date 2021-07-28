class SetDefaultGameStateToPending < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:games, :state, 'pending')
  end
end
