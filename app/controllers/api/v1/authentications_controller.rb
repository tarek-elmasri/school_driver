class Api::V1::AuthenticationsController < ApplicationController

  before_action :validate_credentials , only: [:create]

  def create
    if params[:step] == "1"
      token = Token.generator(@user.phone_no)
      SendOtpJob.perform_later(@user.phone_no, token.otp)
      return render json: {token: {code: token.code}}

    elsif params[:step] == "2"
      token= Token.find_by(token_params, phone_no: @user.phone_no)
      if token&.active?
        #check if refresh token have same current session version 
        check_current_session_version

        session[:refresh_token] = @user.refresh_token
        return render json: @user.tokens
      else
        return invalid_params(:invalid_token)
      end

    else
      return invalid_params(:step_required)
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
    @user = User.auth(user_params)
    return un_authorized(:invalid_credentials) unless @user.present?
  end

  def check_current_session_version
    decoder = JWT_Handler::Decoder.new(@user.refresh_token)
    unless decoder.payload[:session_version] == @user.session_version
      @user.reset_refresh_token
    end
  end
end
