class LocationsController < ApplicationController

  def index
    locations = Location.all
    render :json => locations.to_json
  end

  def show
    user = User.find_by_token(params[:user_token])
    if user.search_male==true && user.search_female==false
      location = Location.joins(:users).where('users.gender = ?', 'male')
        .where("users.age <= ?", user.search_range).where(token: params[:token])
      render :json => location.first, :include => [:users]
    elsif user.search_male==false && user.search_female==true
      location = Location.joins(:users).where('users.gender = ?', 'female')
        .where("users.age <= ?", user.search_range).where(token: params[:token])
      render :json => location.first, :include => [:users]
    else
      location = Location.joins(:users)
        .where("users.age <= ?", user.search_range).where(token: params[:token])
      render :json => location.first, :include => [:users]
    end
  end

  private
    def set_company
      location = Location.find_by_name(params[:name])
    end
end
