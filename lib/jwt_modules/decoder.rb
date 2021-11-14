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
      self.payload = data.first.symbolize_keys
      self.headers = data.last.symbolize_keys
      
      if options[:type].present?
        return false unless options[:type] == headers[:type].to_sym
      end

      if options[:version].present?
        return false unless options[:version] == headers[:version].to_i
      end

      true
      rescue
        return false
    end
  end
end