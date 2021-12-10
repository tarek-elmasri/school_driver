class Child < ApplicationRecord
  belongs_to :parent
  belongs_to :school
  belongs_to :drive_request
end
