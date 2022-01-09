class AddFormattedLocationsToDriveRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :drive_requests, :pickup_formatted_location, :string
    add_column :drive_requests, :drop_formatted_location, :string
  end
end
