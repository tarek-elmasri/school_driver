class Token < ApplicationRecord
  has_secure_token :code

  validates :otp , presence: true
  validates :code , presence: true
  validates :expires_in , presence: true 
  validates :phone_no , presence:true , uniqueness: true

  def self.generator(phone_no , expires_in= 2.minutes.from_now) 
    token = where(phone_no: phone_no).first_or_initialize
    return token  unless token.exceed_intervals?
    token.regenerate! expires_in: expires_in
    return token
  end

  def regenerate!(options = {expires_in: 2.minutes.from_now})
    self.otp = rand(1000...9999)
    self.expires_in = options[:expires_in]
    self.regenerate_code
    self.save
  end


  def exceed_intervals?
    return true if self.updated_at.nil?
    (Time.current - self.updated_at) > 30
    
  end

  def expired? 
    Time.current > expires_in
  end

  def active?
    return false if expired?
    true
  end

end
