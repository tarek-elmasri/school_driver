class Vehicle < ApplicationRecord
  belongs_to :driver

  
  has_one_attached :image
  has_one_attached :licence_card
  has_one_attached :insurance_card

  validates :model, presence: true
  validates :manufacture_year, numericality: {only_integer: true}
  validates :plate_no, presence: true
  validates :capacity, numericality: {only_integer: true}

  
end
