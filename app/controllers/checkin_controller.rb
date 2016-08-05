class CheckinController < ApplicationController

  def create
    @current_user = User.find_by_token(params[:user_token])
    @checkin = Checkin.new(checkin_params)
    @checkin.user = @current_user
    @current_user.update_attributes(checkin_params[:user_attributes])
    @location = Location.find_by_id(params[:location_id])
    @checkin.location = @company
    if @checkin.save
      render json: @checkin
    end
  end

  private

  def checkin_params
    params.require(:checkin).permit(:id, :rate, user_attributes: [:id, :name])
  end

end
