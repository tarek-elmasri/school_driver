class Current < ActiveSupport::CurrentAttributes
  attribute :user , :request , :token, :parent , :driver

  def set_request request 
    require "jwt_modules/decoder"

    self.request = request

    access_token = request.headers[:Authorization]
                        &.split('Bearer ')
                        &.last
    self.token = JWT_Handler::Decoder.new access_token
  end

  def set_user user 
    self.user= user
    user.type == :parent ? 
            self.parent = user.parent : self.driver = user.driver 
  end
end