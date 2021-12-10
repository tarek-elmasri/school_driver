class Api::V1::DriveRequestsController < ApplicationController

  before_action :authenticate_user

  def create 
    puts "------------",params[:drive_request][:lat]
    drive_request = DriveRequest.new(drive_request_params)
    return un_authorized unless authorized_request_for(:create_drive_request , drive_request.parent) 
    #drive_request.pickup_coords = Locations::Location.new(pickup_location_params).merged_cords
    #drive_request.drop_coords = Locations::Location.new(drop_location_params).merged_cords
    
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
    )
  end

  def pickup_location_params
    params.require(:drive_request).permit(pickup_coords: [:lat,:long])
  end
  def drop_location_params
    params.require(:drive_request).permit(drop_coords: [:lat,:long])
  end
  
end
