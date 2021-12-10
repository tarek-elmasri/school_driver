class Parent < ApplicationRecord
  belongs_to :user
  has_many :children
  has_many :drive_requests
end
