class CheckinController < ApplicationController

  def create
    current_user = User.find_by_token(params[:user_token])
    checkin = Checkin.create
    place = Place.create
    place.user = current_user
    checkin.user = current_user
    location = Location.find_by_token(params[:location_token])
    place.location = location
    checkin.location = location
    if checkin.save && place.save
      render json: checkin
    end
  end

  # private
  #
  # def checkin_params
  #   params.require(:checkin).permit(:id, user_attributes: [:id, :name])
  # end

end
