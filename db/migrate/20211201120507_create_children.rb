class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children, id: :uuid do |t|
      t.belongs_to :parent, null: false, foreign_key: true, type: :uuid
      t.string :name , null:false
      t.date :dob, null: false
      t.string :gender , null:false
      t.string :school_class
      t.string :school_grade
      t.belongs_to :school, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
