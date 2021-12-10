class Child < ApplicationRecord
  belongs_to :parent
  belongs_to :school
  belongs_to :drive_request

  scope :set_drive_request, -> (request_id) { update_all({:request_id => request_id})}

end
