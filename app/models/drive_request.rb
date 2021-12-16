class DriveRequest < ApplicationRecord
  belongs_to :school
  belongs_to :parent
  has_many :children, dependent: :nullify

  STATUS = ["pending", "acomplished" , "canceled" ]
  TRIP_TYPES = ["pickup" , "drop", "rounded" ]
  # TODO : add translation to messages and complete validations.
  validates :status, inclusion: STATUS
  validates :trip_type , inclusion: {in: TRIP_TYPES, message: "eithe pickup drop or rounded"} , :if => :is_single_trip?
  validate :children_involved_ids, :min_children_count, :trip_coords_presence

  after_initialize :set_defaults
  before_validation :set_coords
  after_save :link_children_to_request

  attr_accessor :children_involved , :trip_type
  attr_reader :pickup_location , :drop_location


  def is_round_trip? 
    round_trip
  end

  def is_single_trip? 
    !is_round_trip?
  end

  def pickup_location= location
    @pickup_location = Locations::Location.new location
  end

  def drop_location= location
   @drop_location = Locations::Location.new location
  end

  private
  def trip_coords_presence
    case is_round_trip?
    when true
      errors.add(:pickup_coords, I18n.t(:pickup_coords_required)) if pickup_coords.blank?
      errors.add(:drop_coords, I18n.t(:drop_coords_required)) if drop_coords.blank?
    when false
      errors.add(:pickup_coords, I18n.t(:pickup_coords_required)) if pickup_coords.blank? && trip_type == "pickup"
      errors.add(:drop_coords, I18n.t(:drop_coords_required)) if drop_coords.blank? && trip_type == "drop"
    end
  end

  def set_defaults
    self.status ||= "pending"
    self.trip_type ||= "rounded" if is_round_trip?
    self.pickup_location ||= Locations::Location.new(pickup_coords) if pickup_coords
    self.drop_location ||= Locations::Location.new(drop_location) if drop_coords
    self.children_involved ||= children.ids
  end

  def link_children_to_request
    Child
      .where(id: children_involved)
      .set_drive_request(id)
  end

  def set_coords
    self.pickup_coords = pickup_location.to_s if pickup_location
    self.drop_coords = drop_location.to_s if drop_location
  end

  def children_involved_ids
    return if children_involved.empty?
    #make sure all children supplied are there and in related parent scope
    required_children = Child.where(id: children_involved, parent_id: parent_id, school_id: school_id)
    errors.add(:children_involved, I18n.t(:invalid_children_involved_ids)) unless required_children.size == children_involved.length
  end

  def min_children_count
    errors.add(:children_involved, I18n.t(:involved_children_required)) if children_involved.empty?
  end

end
