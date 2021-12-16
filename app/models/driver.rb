class Driver < ApplicationRecord
  belongs_to :user

  has_one_attached :personal_license_card 
  has_one_attached :id_card
  has_one_attached :car_license_card

end
