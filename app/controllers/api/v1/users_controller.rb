class Api::V1::UsersController < ApplicationController
      before_action :set_user , only: [:create]
      before_action :authenticate_user, only: [:me]
      
      def me 
        render json: Current.user, include: [
          'parent.children', 
          'parent.children.school',
          'parent.children.drive_request', 
          'parent.drive_requests.children',
          'parent.drive_requests.children.school'
        ]

      end


      def create
        if params[:step] == "1"
          new_token = Token.generator(@user.phone_no)
          SendOtpJob.perform_later(@user.phone_no, new_token.otp)
          return render json: {token: {code: new_token.code}}

        elsif params[:step] == "2"
          token= Token.find_by(token_params, phone_no: @user.phone_no)
          if token&.active?
            @user.save
            session[:refresh_token] = @user.refresh_token
            return render json: @user.tokens
          else
            return invalid_params(:invalid_token)
          end

        else
          return invalid_params(:step_required)
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