class Api::V1::ChildrenController < ApplicationController

  before_action :authenticate_user
  before_action :set_child , only: [:update,:destroy]
  before_action :set_parent , only: [:create, :update]
  before_action :set_school , only: [:create, :update]

  def create
    return un_authorized unless authorized_request_for(:add_child, @parent)
    
    child = Child.new(child_params)
    if child.save
      render json: child
    else
      return invalid_params(child.errors)
    end
  end

  def update
    return un_authorized unless authorized_request_for(:update_child , @child.parent)
    if @child.update(child_params)
      render json: @child
    else
      return invalid_params(@child.errors)
    end
  end


  def destroy
    return unauthorized unless authorized_request_for(:delete_child , @child.parent)
    if @child.destroy
      render json: @child
    else
      return invalid_params(@child.errors)
    end
  end


  private
  def child_params
    params.require(:child).permit(
      :name, :dob,:gender,:school_class,:school_grade,:school_id,:parent_id
    )
  end

  def set_parent
    @parent= Parent.find_by(id: params[:child][:parent_id])
    return invalid_params({parent: [I18n.t(:invalid_parent_id)]}) unless @parent
  end

  def set_school
    @school = School.find_by(id: params[:child][:school_id])
    return invalid_params({school: [I18n.t(:invalid_school_id)]}) unless @school
  end

  def set_child
    @child = Child.find_by(id: params[:child][:id])
    return invalid_params({child: [I18n.t(:invalid_child_id)]}) unless @child
  end

end
