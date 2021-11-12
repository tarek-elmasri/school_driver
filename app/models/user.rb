require "jwt_modules/auth_tokens"
class User < ApplicationRecord
  include JWT_Handler::AuthTokens

  has_secure_password

  has_one :parent
  has_one :driver

  attr_reader :type

  accepts_nested_attributes_for :parent
  accepts_nested_attributes_for :driver

  validates :email , 
        presence: { message: I18n.t(:email_absent)},
        uniqueness: {message: I18n.t(:Email_already_exists) } 
        
  validates :password ,
        length: {minimum: 5, message: I18n.t(:password_short) }

  validates :phone_no,
        length: {minimum: 12, maximum: 12 , message: I18n.t(:invalid_phone_no)},
        numericality: {only_integer: true, message: I18n.t(:invalid_phone_no)},
        uniqueness: {message: I18n.t(:phone_already_exists)}
  
  validate :type_specified 

  def self.auth(credentials)
    find_by(phone_no: credentials[:phone_no])
    &.authenticate credentials[:password]
  end

  def type 
    (is_parent?) ? :parent : :driver
  end

  def is_parent?
    parent.present?
  end

  def is_driver? 
    driver.present?
  end

  private
  def type_specified
    errors.add(:type, I18n.t(:unspecified_user_type)) if (parent.nil? && driver.nil?)
    errors.add(:type , I18n.t(:mixed_type_user)) if (is_parent? && is_driver? )
  end

end
