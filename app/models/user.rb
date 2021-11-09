require "jwt_handler"
class User < ApplicationRecord
  require "jwt_handler"
  include JWT_Handler::AuthTokens

  has_secure_password

  has_one :parent
  has_one :driver

  accepts_nested_attributes_for :parent
  accepts_nested_attributes_for :driver

  validates :email , 
        presence: { message: I18n.t("email_absent")},
        uniqueness: {message: I18n.t("Email_already_exists") } 
        
  validates :password ,
        length: {minimum: 5, message: I18n.t("password_short") }

  validates :phone_no,
        length: {minimum: 12, maximum: 12 , message: I18n.t("invalid_phone_no")},
        numericality: {only_integer: true, message: I18n.t("invalid_phone_no")}
  
  validate :type_specified

  scope :auth, lambda {|credentials|
    find_by(phone_no: credentials[:phone_no])
    &.authenticate(credentials[:password])
  }

  private
  def type_specified
    errors.add(:type, I18n.t("unspecified_user_type")) if (parent.nil? && driver.nil?)
    errors.add(:type , I18n.t("mixed_type_user")) if (parent.present? && driver.present? )
  end

end
