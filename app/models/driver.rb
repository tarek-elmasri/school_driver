class Driver < ApplicationRecord
  belongs_to :user

  has_one_attached :personal_license_card 
  has_one_attached :id_card
  has_one_attached :car_license_card

  validates :first_name, presence: {message: I18n.t(:first_name_required)}
  validates :last_name, presence: { message: I18n.t(:last_name_required)}
  validates :dob , presence: {message: I18n.t(:dob_required)}
  validate :age_in_accepted_range



  def age 
    return unless dob
    ((Time.now.utc - dob.to_time) / 1.year.seconds).floor
  end


  private
  def age_in_accepted_range
    return unless dob
    errors.add(:age , I18n.t(:invalid_dob)) if age < 18 || age > 70
  end
end
