class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  require "jwt_modules/decoder"
  before_action :set_request

  protected
  def set_request 
    Current.request = request 
    access_token = request.headers[:Authorization]
                    &.split("Bearer ")
                    &.last
    Current.token = JWT_Handler::Decoder.new access_token, {:type => :ACCESS_TOKEN}
  end

  def authenticate_user
    if Current.token.valid?
      Current.user = User.find(Current.token.payload[:id])
    else
      return un_authorized(:invalid_access_token)
    end 
  end

  def authorized_request_for authorization_type , owner=nil 
    Current.user.is_authorized_for? authorization_type, owner
  end

  def un_authorized(msg= :un_authorized) 
    render json: {:errors => I18n.t(msg)}, status: :unauthorized
  end

  def invalid_params(msg)
    render json: {errors: msg},status: 422
  end
end
