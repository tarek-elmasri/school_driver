class CreateOtps < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens , id: :uuid do |t|
      t.integer :otp
      t.string :code 
      t.string :phone_no 
      t.timestamp :expires_in

      t.timestamps
    end
    add_index :tokens , :phone_no , unique: true
  end
end
