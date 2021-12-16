class CreateOtps < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens , id: :uuid do |t|
      t.integer :otp , null: false
      t.string :code ,null:false
      t.string :phone_no , null:false
      t.timestamp :expires_in, null:false

      t.timestamps
    end
    add_index :tokens , :phone_no , unique: true
  end
end
