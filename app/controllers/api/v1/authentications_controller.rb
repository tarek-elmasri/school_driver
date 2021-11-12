class Api::V1::AuthenticationsController < ApplicationController
  before_action :validate_credentials , only: [:new,:create]

  def new
    response = Sms::OtpService.new(Current.user.phone_no).call
    render json: response
  end

  def create
    token= Token.find_by(token_params, phone_no: Current.user.phone_no)
    if token&.active?
      # reset refresh token forces any other device to be logged off
      Current.user.reset_refresh_token
      render json: user_data
    else
      render json: {
        errors: {errors: I18n.t("invalid_token")}
        },status: :unauthorized
    end
  end

  def refresh
    require "jwt_modules/decoder"
    decoder = JWT_Handler::Decoder.new(refresh_token_params[:refresh_token])
    user = User.find_by(refresh_token: decoder.token)
    
    if user.present? && decoder.valid?(:type => :REFRESH_TOKEN)
      render json: user_data
    else
      render json: { errors: "invalid_refresh_token"},status: :unauthorized
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
    render json: {errors: I18n.t("invalid_credentials")},status: :unauthorized unless Current.user.present?
  end

  def user_data
    {
      user: {
        data: "user data"
      },
      token: {
        access_token: Current.user.generate_access_token , 
        refresh_token: Current.user.refresh_token
      } 
    }
  end
end
