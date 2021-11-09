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

  def decode token 
    JWT.decode token , JWT_Handler::JWT_SECRET_KEY , true , { algorithm: 'HS256' }
  end

  module AuthTokens
    extend ActiveSupport::Concern

    attr_accessor :access_token_fields , :refresh_token_fields

    included do
      after_initialize {
        self.access_token_fields = [:id]
        self.refresh_token_fields = [:id]
      }
      before_create {self.refresh_token= self.generate_refresh_token}
      after_create { self.reset_refresh_token if refresh_token_fields.include?(:id) }
    end

    def generate_access_token
      payload = self.generate_payload access_token_fields
      JWT_Handler.encode payload: payload , expires_in: 1.week.from_now , headers: {type: :ACCESS_TOKEN }
    end


    def reset_refresh_token
      update :refresh_token => self.generate_refresh_token
    end

    def generate_refresh_token
      payload = self.generate_payload refresh_token_fields
      JWT_Handler.encode payload: payload , expires_in: 1.month.from_now , headers: {type: :REFRESH_TOKEN }
    end
  
    def generate_payload fields 
      payload= {}
      fields.each do |field|
        payload[field] = send("#{field}")
      end
      payload
    end
    
  end

end