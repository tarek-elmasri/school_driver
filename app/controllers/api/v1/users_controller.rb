class Api::V1::UsersController < ApplicationController
      before_action :set_user , only: [:new, :create]
      before_action :authenticate_user, only: [:me]
      
      def me 
        return render json: Current.user
      end

      def new
        response = Sms::OtpService.new(Current.user.phone_no).call
        return render json: response
      end


      def create
        token= Token.find_by(token_params, phone_no: Current.user.phone_no)
        if token&.active?
          Current.user.save
          return render json: Current.user.tokens
        else
          return un_authorized(:invalid_token)
        end
        
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
        render json: {errors: Current.user.errors },status: 422 unless Current.user.valid?
      end




    end