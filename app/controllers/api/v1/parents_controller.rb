class Api::V1::ParentsController < ApplicationController

  before_action :authenticate_user

  # def create
  #   child = Children.new(children_params)
  #   return un_authorized(:unauthorized) unless 
  #             Current.user.is_authorized_for? :create_user , child

  #   if child.save 
  #     return render json: child
  #   else
  #     return render json: {errors: child.errors},:status: :un_processable_entity
  #   end

  # end

  def update
    
    parent = Parent.find_by(id: params[:id])
    return un_authorized(:unauthorized) unless parent && authorized_request_for(:update_parent , parent)

    if parent.update(parent_params)
      return render json: parent
    else
      return render json: { errors: parent.errors}
    end

  end

  def destroy
    parent = Parent.find_by(id: params[:id])
    return un_authorized(:unauthorized) unless parent && authorized_request_for(:delete_parent , parent)
    if parent.delete 

    else

    end
  end

  private 

  def parent_params
    params.require(:parent).permit(:first_name,:last_name)
  end

  def authorized_request_for authorization_type , instance 
    Current.user.is_authorized_for? authorization_type, instance
  end
end
