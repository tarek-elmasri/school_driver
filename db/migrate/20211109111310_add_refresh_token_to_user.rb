class AddRefreshTokenToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :refresh_token, :string , null: false
  end
end
