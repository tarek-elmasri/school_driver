class AddTokensVersionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :tokens_version, :integer, null: false , default: 0
  end
end
