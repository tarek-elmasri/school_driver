module JWT_HANDLER
  JWT_SECRET_KEY =  ENV['JWT_SECRET_KEY'] 
  DEFAULT_EXPIRE_TIME=  1.hour.from_now.to_i
  DEFUALT_ISSUER = "SD_API"
  HEADERS=  {type: "JWT"}

  def encode (data={})
    payload = data[:payload] || {}
    payload[:exp] = data[:expires_in]&.to_i || JWT_HANDLER::DEFAULT_EXPIRE_TIME
    payload[:iss] = JWT_HANDLER::DEFUALT_ISSUER
    #payload[:sub]= data[:purpose] || "TEMP"

    headers = JWT_HANDLER::HEADERS
    if data[:headers].present?
      data[:headers].map {|k,v| headers[k] = v}
    end

    token = JWT.encode(payload , JWT_HANDLER::JWT_SECRET_KEY, 'HS256', headers)
  end

  def decode token 
    JWT.decode token , JWT_HANDLER::JWT_SECRET_KEY , true , { algorithm: 'HS256' }
  end

  module TOKENS
    def generate_access_token
      puts JWT_HANDLER::HEADERS
    end
  end

end