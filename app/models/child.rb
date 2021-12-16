class Child < ApplicationRecord
  belongs_to :parent
  belongs_to :school
  belongs_to :drive_request , optional: true

  validates :name , presence: { message: I18n.t(:name_is_required)}
  validates :gender , inclusion: {in: ["male", "female"] , message: I18n.t(:invalid_gender_type)}
  validates :dob , presence: {message: I18n.t(:dob_required)}
  validate :age_in_accepted_range
  scope :set_drive_request, -> (request_id) { update_all({:drive_request_id => request_id})}


  def age 
    return unless dob
    ((Time.now.utc - dob.to_time) / 1.year.seconds).floor
  end

  private
  def age_in_accepted_range
    return unless dob
    errors.add(:age , I18n.t(:invalid_dob)) if age < 1 || age > 60
  end
end
