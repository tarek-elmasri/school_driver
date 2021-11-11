class ApplicationController < ActionController::API

    protected
    def authenticate_user
        require "jwt_modules/decoder"
        access_token = request.headers[:Authorization]
                        &.split('Bearer ')
                        &.last

        token = JWT_Handler::Decoder.new access_token
        
        if token.valid? :type => :ACCESS_TOKEN
            Current.user = User.find(token.payload[:id])
        else
            render json: {error: I18n.t(:invalid_access_token)},status: :unauthorized
        end
    end
end
