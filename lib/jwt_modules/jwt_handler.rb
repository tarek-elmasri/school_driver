require "app_exceptions/custom_errors"

module JWT_Handler

  JWT_SECRET_KEY =  ENV['JWT_SECRET_KEY'] 
  DEFAULT_EXPIRE_TIME=  1.hour.from_now.to_i
  DEFUALT_ISSUER = "SD_API"
  HEADERS=  {type: "JWT"}

  def self.encode (data={})
    payload = data[:payload] || {}
    payload[:exp] = data[:expires_in]&.to_i || JWT_Handler::DEFAULT_EXPIRE_TIME
    payload[:iss] = JWT_Handler::DEFUALT_ISSUER
    #payload[:sub]= data[:purpose] || "TEMP"

    headers = JWT_Handler::HEADERS
    if data[:headers].present?
      data[:headers].map {|k,v| headers[k] = v}
    end

    token = JWT.encode(payload , JWT_Handler::JWT_SECRET_KEY, 'HS256', headers)
  end

  def self.decode token 
    JWT.decode token , JWT_Handler::JWT_SECRET_KEY , true , { algorithm: 'HS256' }
  end

  

end