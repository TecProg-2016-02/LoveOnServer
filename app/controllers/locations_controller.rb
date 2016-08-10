class LocationsController < ApplicationController

  def index
    locations = Location.all
    render :json => locations.to_json
  end

  def show
    location = Location.find_by_token(params[:token])
    user = User.find_by_token(params[:user_token])
    if user.search_male==true && user.search_female==false
      render :json => location, :methods => [:male_users]
    elsif user.search_male==false && user.search_female==true
      render :json => location, :methods => [:female_users]
    else
      render :json => location, :include => [:users]
    end
  end

  private
    def set_company
      location = Location.find_by_name(params[:name])
    end
end
