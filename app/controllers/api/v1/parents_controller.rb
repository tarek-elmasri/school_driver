class Api::V1::ParentsController < ApplicationController

  before_action :authenticate_user

  def update
    parent = Parent.find_by(id: params[:id])
    return un_authorized(:un_authorized) unless parent && authorized_request_for(:update_parent , parent)

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

end
