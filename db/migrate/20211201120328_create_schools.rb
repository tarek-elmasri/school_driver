class CreateSchools < ActiveRecord::Migration[6.1]
  def change
    create_table :schools, id: :uuid do |t|
      t.string :a_name, null: false
      t.string :e_name, null:false
      t.string :lat, null:false
      t.string :long, null: false

      t.timestamps
    end
  end
end
