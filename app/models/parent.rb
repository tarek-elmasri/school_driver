class Parent < ApplicationRecord
  belongs_to :user
  has_many :children
  has_many :drive_requests

  validates :first_name, presence: { message: I18n.t(:first_name_required)}
  validates :last_name , presence: { message: I18n.t.(:last_name_required)}

end
