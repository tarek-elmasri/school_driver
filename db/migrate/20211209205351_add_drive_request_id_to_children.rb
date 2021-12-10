class AddDriveRequestIdToChildren < ActiveRecord::Migration[6.1]
  def change
    add_reference :children, :drive_request, null: true, foreign_key: true, type: :uuid
  end
end
