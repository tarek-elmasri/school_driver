class Api::V1::DriveRequestsController < ApplicationController

  before_action :authenticate_user
  before_action :set_children_array, only: [:create]

  def create 
    drive_request = DriveRequest.new(drive_request_params)
    return un_authorized unless authorized_request_for(:create_drive_request , drive_request.parent) 
    
    drive_request.children = @children
    drive_request.pickup_coords = Location.new(pickup_location_params).merged_cords
    drive_request.drop_coords = Location.new(drop_location_params).merged_cords
    drive_request.status = "pending"
  end

  private

  def set_children_array
    begin
      child_list = params.require(:drive_request).permit(:children)
      allowed_children_parameter_classes = [Array , String]
      raise StandardError.new("invalid params.") unless allowed_children_parameter_classes.include?(child_list.class)
      raise StandardError.new("invalid params.") unless drive_request_params[:parent_id].class == String
      
      @children = Child.where(id: child_list , parent_id: driver_request_params[:parent_id])
      return invalid_params(:invalid_child_id) unless child_list.length ==  @children.size

    rescue
      render json: {errors: {children: "children must be an array of children ids or single id."}},status: 400
    end
  end

  def drive_request_params
    params.require(:drive_request).permit(
      :parent_id,
      :school_id,
      :round_trip,
      :pickup_time,
      :drop_time,
    )
  end

  def pickup_location_params
    params.require(:drive_request).permit(pickup_coords: [:lat,:long])
  end
  def drop_location_params
    params.require(:drive_request).permit(drop_coords: [:lat,:long])
  end
  
end
