class Api::V1::UsersController < ApplicationController
      before_action :set_user , only: [:new, :create]
      before_action :authenticate_user, only: [:me]
      
      def me 
        render json: Current.user, include: ['parent.children', 'parent.children.school']
      end

      def new
        response = Sms::OtpService.new(@user.phone_no).call
        render json: response
      end


      def create
        token= Token.find_by(token_params, phone_no: @user.phone_no)
        if token&.active?
          @user.refresh_token_fields << :session_version
          @user.save
          session[:refresh_token] = @user.refresh_token
          render json: @user.tokens
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
        @user = User.new(new_user_params)
        return invalid_params(@user.errors) unless @user.valid?
      end




    end