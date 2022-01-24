class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles, id: :uuid do |t|
      t.string :model
      t.integer :manufacture_year
      t.string :plate_no
      t.integer :capacity
      t.belongs_to :driver, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :vehicles, :plate_no, unique: true
  end
end
