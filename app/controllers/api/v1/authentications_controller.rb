class Api::V1::AuthenticationsController < ApplicationController
  before_action :validate_credentials , only: [:new,:create]
  before_action :validate_token, only: [:create]

  def new
    #user< generate refresh_token
    # return access_token , refresh_token , user_data
  end

  def create

  end

  def refresh
    
  end

  private
  def user_params
    params.require(:user).permits(:phone_no, :password)
  end

  def validate_credentials
    @user = User.auth(user_params)
    render json: {errors: I18n.t("invalid_credentials")},status: :unauthorized unless @user.present?
  end
end
