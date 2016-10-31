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

    # after the user have a checkin in a place,the information will be saved, if isn't saved will return nothing to the user
    if checkin.save && place.save
      render json: checkin
    else
      render :nothing
    end

  end
end
