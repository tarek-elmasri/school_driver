class Api::V1::DriveRequestsController < ApplicationController

  before_action :authenticate_user

  def create 
    drive_request = DriveRequest.new(drive_request_params)
    
    return un_authorized unless authorized_request_for(:create_drive_request , drive_request.parent)
    
    if drive_request.valid?
      render json: drive_request
    else
      return invalid_params(drive_request.errors)
    end
  end

  private

  def drive_request_params
    params.require(:drive_request).permit(
      :parent_id,
      :school_id,
      :round_trip, # default => false
      :trip_type, # => required only if round_trip is false or absent
      :pickup_time,
      :drop_time,
      children_involved: [],
      pickup_location: [:lat , :long],
      drop_location: [:lat, :long]
    )
  end
  
end
