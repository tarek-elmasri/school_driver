class School < ApplicationRecord
  has_many :children
  has_many :drive_requests
end
