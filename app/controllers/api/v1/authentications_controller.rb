class Api::V1::AuthenticationsController < ApplicationController
  require "jwt_modules/decoder"

  before_action :validate_credentials , only: [:new,:create]

  def new
    response = Sms::OtpService.new(Current.user.phone_no).call
    render json: response
  end

  def create
    token= Token.find_by(token_params, phone_no: Current.user.phone_no)
    if token&.active?
      render json: Current.user.tokens
    else
      return un_authorized(:invalid_token)
    end
  end

  def refresh
    decoder = JWT_Handler::Decoder.new(refresh_token_params[:refresh_token])
    return un_authorized(:invalid_refresh_token) unless decoder.valid?(:type => :REFRESH_TOKEN)

    user = User.find_by(refresh_token: decoder.token)
    if user
      render json: user.tokens
    else
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

  def refresh_token_params
    params.permit(:refresh_token)
  end

  def validate_credentials
    Current.user = User.auth(user_params)
    return un_authorized(:invalid_credentials) unless Current.user.present?
  end

end
