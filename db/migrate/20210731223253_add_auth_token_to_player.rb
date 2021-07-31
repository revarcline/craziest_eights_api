class AddAuthTokenToPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :auth_token, :string
  end
end
