class CreateOtps < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens , id: :uuid do |t|
      t.integer :otp
      t.string :code , unique: true
      t.string :phone_no , unique: true
      t.timestamp :expires_in

      t.timestamps
    end
  end
end
