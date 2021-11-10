class Api::V1::UsersController < ApplicationController
      before_action :validate_user_params , only: [:new, :create]
      before_action :validate_token, only: [:create]

      def new
        response = Sms::OtpService.new(Current.user.phone_no).call
        return render json: response
      end


      def create
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

      def validate_user_params
        Current.user = User.new(new_user_params)
        render json: {errors: Current.user.errors },status: :forbidden unless Current.user.valid?
      end




    end