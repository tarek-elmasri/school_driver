class Api::V1::ChildrenController < ApplicationController

  before_action :authenticate_user
  

  def create
    parent= Parent.find_by(id: params[:child][:parent_id])
    school = School.find_by(id: params[:child][:school_id])
    puts params[:child][:parent_id]
    return render json: {errors: {parent_id: ["invalid parent id."]}},status: 422 unless parent
    return render json: {errors: {school_id: ["invalid school id."]}},status: 422 unless school
    return un_authorized(:unauthorized) unless authorized_request_for(:add_child, parent)

    child = Child.new(child_params)
    if child.save
      render json: child
    else
      render json: {errors: child.errors},status: 422
    end

  end

  def update

  end


  def destroy
    child = Child.find_by(id: params[:child][:id])
    if child && authorized_request_for(:delete_child , child.parent)
      child.destroy
    else

    end
  end


  private
  def child_params
    params.require(:child).permit(
      :name, :age,:sex,:school_class,:school_grade,:school_id,:parent_id
    )
  end

end
