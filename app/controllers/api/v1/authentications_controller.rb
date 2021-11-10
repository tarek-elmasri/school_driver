class Api::V1::AuthenticationsController < ApplicationController
  before_action :validate_credentials , only: [:new,:create]

  def new
    puts Current.user
    response = Sms::OtpService.new(Current.user.phone_no).call
    return render json: response
  end

  def create
    token= Token.find_by(token_params, phone_no: Current.user.phone_no)
    return render json: {
      errors: {token: I18n.t("invalid_token")}
      },status: :unauthorized unless token&.active?
    
    # reset refresh token forces any other device to be logged off
    Current.user.reset_refresh_token

    render json: {
      user: {
        data: "user data"
      },
      token: {
        access_token: Current.user.generate_access_token , 
        refresh_token: Current.user.refresh_token
        } 
      }
  end

  def refresh
    
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
    puts Current.user
    render json: {errors: I18n.t("invalid_credentials")},status: :unauthorized unless Current.user.present?
  end
end
