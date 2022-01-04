class DriveRequestSerializer < ActiveModel::Serializer 
  attributes :id, :status , :round_trip , :trip_type, :pickup_location , :drop_location
  has_many :children
  belongs_to :parent 
  belongs_to :school

  def pickup_location
    object.pickup_location.coords unless object.pickup_location.blank?
  end

  def drop_location
    object.drop_location.coords unless object.drop_location.blank?
  end
end