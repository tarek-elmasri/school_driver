class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children, id: :uuid do |t|
      t.belongs_to :parent, null: false, foreign_key: true, type: :uuid
      t.string :name , null:false
      t.string :age, null: false
      t.string :sex
      t.string :class
      t.string :grade
      t.belongs_to :school, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
