class ApplicationController < ActionController::API
    before_action {Current.fetch_token request}

    protected
    def authenticate_user
        if Current.token.valid? :type => :ACCESS_TOKEN
            Current.user = User.find(Current.token.payload[:id])
        else
            return un_authorized(:invalid_access_token)
        end
    end

    def un_authorized msg 
        render json: {:errors => I18n.t(msg)}, status: :unauthorized
    end

end
