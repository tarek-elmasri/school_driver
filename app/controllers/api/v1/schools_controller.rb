class Api::V1::SchoolsController < ApplicationController

  before_action :authenticate_user

  def index
    schools = School.search(params)
    render json: schools
  end

  def create
    return un_authorized unless authorized_request_for(:create_school)

    school= School.new(school_params)
    if school.save 
        render json: school
    else
        return invalid_params(school.errors)
    end
  end


  private
  def school_params
    params.require(:school).permit(:a_name,:e_name,:lat,:long)
  end
end
