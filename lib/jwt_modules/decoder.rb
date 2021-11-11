require "jwt_modules/jwt_handler"

module JWT_Handler
  class Decoder

    attr_accessor :token
    attr_accessor :payload
    attr_accessor :headers

    def initialize token
      self.token=token
    end

    def valid? options= {}
      data = JWT_Handler.decode token
      self.payload = data.first
      self.headers = data.last
      
      if options[:type].present?
        return false unless options[:type] == headers["type"].to_sym
      end

      true
      rescue
        return false
    end
  end
end