class Api::V1::AuthenticationsController < ApplicationController

  before_action :validate_credentials , only: [:new,:create]

  def new
    response = Sms::OtpService.new(Current.user.phone_no).call
    render json: response
  end

  def create
    token= Token.find_by(token_params, phone_no: Current.user.phone_no)
    if token&.active?
      #check if refresh token have same current session version 
      check_current_session_version

      session[:refresh_token] = Current.user.refresh_token
      render json: Current.user.tokens
    else
      return un_authorized(:invalid_token)
    end
  end

  def refresh
    decoder = JWT_Handler::Decoder.new session[:refresh_token]

    user = User.find_by(refresh_token: decoder.token)
    if user && user.session_version == decoder.payload[:session_version]
      render json: user.tokens
    else
      session[:refresh_token] = nil
      return un_authorized(:invalid_refresh_token)
    end
  end

  private
  def user_params
    params.require(:user).permit(:phone_no, :password)
  end

  def token_params
    params.require(:token).permit(:code,:otp)
  end

  def validate_credentials
    Current.user = User.auth(user_params)
    return un_authorized(:invalid_credentials) unless Current.user.present?
  end

  def check_current_session_version
    decoder = JWT_Handler::Decoder.new(Current.user.refresh_token)
    unless decoder.payload[:session_version] == Current.user.session_version
      Current.user.refresh_token_fields << :session_version
      Current.user.reset_refresh_token
    end
  end
end
