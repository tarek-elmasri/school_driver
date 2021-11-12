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
            render json: errors_msg(:invalid_access_token),status: :unauthorized
        end
    end

    def errors_msg msg 
        { :errors => I18n.t(msg)}
    end
end
