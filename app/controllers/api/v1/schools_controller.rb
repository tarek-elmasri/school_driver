class Api::V1::SchoolsController < ApplicationController

  before_action :authenticate_user

  def index
    schools = School.all 
    render json: schools
  end

  def create
    return un_authorized(:unauthorized) unless authorized_request_for(:create_school)

    school= School.new(school_params)
    if school.save 
        render json: school
    else
        render json: {errors: school.errors},status: 422
    end
  end


  private
  def school_params
    params.require(:school).permit(:a_name,:e_name,:lat,:long)
  end
end
