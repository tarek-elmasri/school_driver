class DriveRequest < ApplicationRecord
  belongs_to :school
  belongs_to :parent
  has_many :children

  STATUS = ["pending", "acomplished" , "canceled" ]
  TRIP_TYPES = ["pickup" , "drop", "rounded" ]
  # TODO : add translation to messages and complete validations.
  validates :school_id , presence: true
  validates :parent_id , presence: true
  validates :status, presence:true , inclusion: STATUS
  validates :trip_type , inclusion: {in: TRIP_TYPES, message: "eithe pickup drop or rounded"}
  validate :min_children_count, :trip_ways_and_times_presence

  after_initialize :set_defaults
  before_validation :set_children 
  after_create :link_children_to_request

  attr_accessor :children_involved , :trip_type, :pickup_location , :drop_location


  def is_round_trip? 
    round_trip
  end

  def is_single_trip? 
    !is_round_trip?
  end


  private
  def trip_ways_and_times_presence
    case is_round_trip?
    when true
      errors.add(:pickup_coords, I18n.t(:pickup_coords_required)) if pickup_coords.blank?
      errors.add(:pickup_time, I18n.t(:pickup_time_required)) if pickup_time.blank?
      errors.add(:drop_coords, I18n.t(:drop_coords_required)) if drop_coords.blank?
      errors.add(:drop_time, I18n.t(:drop_time_required)) if drop_time.blank?
    when false
      errors.add(:pickup_coords, I18n.t(:pickup_coords_required)) if pickup_coords.blank? && trip_type == "pickup"
      errors.add(:pickup_time, I18n.t(:pickup_time_required)) if pickup_time.blank? && trip_type == "pickup"
      errors.add(:drop_coords, I18n.t(:drop_coords_required)) if drop_coords.blank? && trip_type == "drop"
      errors.add(:drop_time, I18n.t(:drop_time_required)) if drop_time.blank? && trip_type == "drop"
    end
  end

  def set_defaults
    self.status ||= "pending"
    self.trip_type ||= "rounded" if is_round_trip?
    self.pickup_location = Locations::Location.new(pickup_coords) if pickup_coords
    self.drop_location ||= Locations::Location.new(drop_location) if drop_coords
    
    self.pickup_coords ||= pickup_location&.to_s
    self.drop_coords ||= drop_location&.to_s
    self.children_involved ||= children.ids
  end

  def link_children_to_request
    self.children.set_drive_request(id)
  end

  def set_children
    return unless children_involved
    self.children = Child.where(id: children_involved, parent_id: parent_id, school_id: school_id)

    #make sure all children supplied are there and in related parent scope
    errors.add(:children_involved, I18n.t(:invalid_children)) unless children.size == children_involved.length
  end

  def min_children_count
    # at least one child involved in request
    errors.add(:children, I18n.t(:child_required)) if children.size < 1
  end

end
