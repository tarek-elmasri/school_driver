class Api::V1::UsersController < ApplicationController
      before_action :set_user , only: [:new, :create]

      def new
        response = Sms::OtpService.new(Current.user.phone_no).call
        return render json: response
      end


      def create
        token= Token.find_by(token_params, phone_no: Current.user.phone_no)
        return render json: {errors: {token: I18n.t("invalid_token")}},status: :unauthorized unless token&.active?
        
        Current.user.save
        render json: {user: {access_token: Current.user.generate_access_token , refresh_token: Current.user.refresh_token} }
      end


      private
      def new_user_params
        params.require(:user).permit(
          :email, :phone_no, :password, 
          parent_attributes: [:first_name , :last_name] , 
          driver_attributes: [:dob]
        )
      end

      def token_params
        params.require(:token).permit(:code,:otp)
      end

      def set_user
        Current.user = User.new(new_user_params)
        render json: {errors: Current.user.errors },status: 400 unless Current.user.valid?
      end




    end