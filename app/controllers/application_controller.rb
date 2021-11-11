class ApplicationController < ActionController::API
    #before_action :authenticate_user

    protected
    def authenticate_user
        require "jwt_modules/jwt_handler"
        token = request.headers[:Authorization]
                        &.split('Bearer ')
                        &.last

        token_data = JWT_Handler.decode token
        
        render json: token_data

    end
end
