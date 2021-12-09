class ApplicationController < ActionController::API
    include ::ActionController::Cookies

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

    def authorized_request_for authorization_type , authorized_requester=nil 
        Current.user.is_authorized_for? authorization_type, authorized_requester
    end
    
    def un_authorized(msg= :un_authorized) 
        render json: {:errors => I18n.t(msg)}, status: :unauthorized
    end

    def invalid_params(msg)
        render json: {errors: msg},status: 422
    end
end
