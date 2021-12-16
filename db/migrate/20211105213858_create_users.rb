class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email , null: false, unique: true
      t.string :phone_no , null: false, unique:true
      t.string :password_digest

      t.timestamps
    end
  end
end
