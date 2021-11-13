class Current < ActiveSupport::CurrentAttributes
  attribute :user , :request , :token

  def fetch_token request 
    require "jwt_modules/decoder"
    
    self.request = request

    access_token = request.headers[:Authorization]
                        &.split('Bearer ')
                        &.last
    self.token = JWT_Handler::Decoder.new access_token
  end
end