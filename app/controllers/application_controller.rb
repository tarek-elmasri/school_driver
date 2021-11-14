class ApplicationController < ActionController::API
    before_action {Current.set_request request}

    protected
    def authenticate_user
        return un_authorized(:invalid_access_token) unless Current.token.valid? :type => :ACCESS_TOKEN

        user = User.find(Current.token.payload[:id])
        if Current.token.valid? :version => user.tokens_version
            Current.set_user user
        else
            return un_authorized(:invalid_access_token)
        end

    end

    def un_authorized msg 
        render json: {:errors => I18n.t(msg)}, status: :unauthorized
    end

end
