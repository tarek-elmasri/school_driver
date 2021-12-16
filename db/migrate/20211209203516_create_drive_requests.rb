class CreateDriveRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :drive_requests, id: :uuid do |t|
      t.belongs_to :school, null: false, foreign_key: true, type: :uuid
      t.belongs_to :parent, null: false, foreign_key: true, type: :uuid
      t.string :status, null:false , default: "pending"
      t.boolean :round_trip , null: false , default: false
      t.string :pickup_coords
      t.string :drop_coords
      t.timestamps
    end
  end
end
