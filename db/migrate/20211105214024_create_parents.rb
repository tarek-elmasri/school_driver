class CreateParents < ActiveRecord::Migration[6.1]
  def change
    create_table :parents, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name , null: false
      t.belongs_to :user,type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
