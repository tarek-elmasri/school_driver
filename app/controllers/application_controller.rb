class ApplicationController < ActionController::API


  def validate_token
    token= Token.find_by(code: params[:token][:code], otp: params[:token][:otp], phone_no: @user.phone_no)
    render json: {errors: {token: I18n.t("invalid_token")}},status: :unauthorized unless token&.active?
  end
end
