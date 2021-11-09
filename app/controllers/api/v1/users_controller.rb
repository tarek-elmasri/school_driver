class Api::V1::UsersController < ApplicationController
      before_action :validate_user_params , only: [:new, :create]
      before_action :validate_token, only: [:create]


      def new
        token = Token.where(phone_no: Current.user.phone_no).first_or_initialize
        return render json: {token: {code: token.code}}  unless token.exceed_intervals?
        token.regenerate! expires_in: 2.minutes.from_now
        require 'sms_service'
        response = SMS_Service.send phone_no: Current.user.phone_no, otp: token.otp
        if response.status == 200
          render json: {token: {code: token.code}}
        else
          # check sms errors
          render json: {errors: {message: I18n.t("sms_service_unavailable")}},status: :forbidden
        end
      end


      def create
        Current.user.save
        render json: {user: {access_token: Current.user.access_token , refresh_token: Current.user.refresh_token} }
      end


      private
      def new_user_params
        params.require(:user).permit(
          :email, :phone_no, :password, 
          parent_attributes: [:first_name , :last_name] , 
          driver_attributes: [:dob]
        )
      end

      def validate_user_params
        Current.user = User.new(new_user_params)
        render json: {errors: Current.user.errors },status: :forbidden unless Current.user.valid?
      end




    end