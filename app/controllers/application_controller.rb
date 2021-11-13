class ApplicationController < ActionController::API
    before_action {Current.fetch_token request}

    protected
    def authenticate_user
        if Current.token.valid? :type => :ACCESS_TOKEN
            Current.user = User.find(Current.token.payload[:id])
        else
            render json: errors_msg(:invalid_access_token),status: :unauthorized
        end
    end

    def errors_msg msg 
        { :errors => I18n.t(msg)}
    end
end
