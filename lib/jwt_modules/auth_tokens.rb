require "jwt_modules/jwt_handler"
require "jwt_modules/access_token"
require "jwt_modules/refresh_token"

module JWT_Handler
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
            increment! :tokens_version
            self.access_token
        end

        def access_token 
            AccessToken.new(self).generate_access_token(tokens_version)
        end


        def reset_refresh_token
            increment! :tokens_version
            update_attribute :refresh_token , generate_refresh_token
        end

        def generate_refresh_token
            RefreshToken.new(self).generate_refresh_token
        end

    end
end