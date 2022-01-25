class Vehicle < ApplicationRecord
  belongs_to :driver

  
  has_one_attached :image
  has_one_attached :licence_card
  has_one_attached :insurance_card

  validates :model, presence: true
  validates :manufacture_year, numericality: {only_integer: true}
  validates :plate_no, presence: true, length: {maximum: 8}
  validates :capacity, numericality: {only_integer: true}

  validates :image, attached: true ,
                     content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                     size: { less_than: 5.megabytes , message: "size is greater than 5 megabytes"}

  validates :licence_card, attached: true ,
                           content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                           size: { less_than: 5.megabytes , message: "size is greater than 5 megabytes"}

  validates :insurance_card , content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                              size: { less_than: 5.megabytes , message: "size is greater than 5 megabytes"}

  validate :vehicle_age, :valid_capacity


  private
  def vehicle_age 
    return unless manufacture_year
    if manufacture_year < (Time.now.year - 20) || manufacture_year > (Time.now.year + 1)
      errors.add(:vehicle_manufacture_year , "invalid manufacture year.")
    end
  end

  def valid_capacity
    return unless capacity
    if capacity < 1 || capacity > 20
      errors.add(:vehicle_capacity, "Allowed capacity is between 1 and 20")
    end
  end

end
