class Api::V1::ParentsController < ApplicationController

  before_action :authenticate_user
  before_action :set_parent

  def update
    return un_authorized unless authorized_request_for(:update_parent , @parent)

    if @parent.update(parent_params)
      render json: @parent
    else
      return invalid_params(@parent.errors)
    end

  end

  private 

  def parent_params
    params.require(:parent).permit(:first_name,:last_name)
  end

  def set_parent
    @parent = Parent.find_by(id: params[:id])
    return invalid_params({parent: [I18n.t(:invalid_parent_id)]}) unless @parent
  end

end
