class LocationsController < ApplicationController

  def index
    @locations = Location.all
    render :json => @locations.to_json
  end
  def show
    @location = Location.find_by_name(params[:name])
    render :json => @location.to_json(:include => :users)
  end

  private
    def set_company
      @location = Location.find_by_name(params[:name])
    end
end
