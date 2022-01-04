class ParentSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name
  has_many :children
  has_many :drive_requests

  
end
