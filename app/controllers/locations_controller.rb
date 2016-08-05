class LocationsController < ApplicationController

  def index
    @locations = Location.all
    render :json => @locations.to_json
  end
  def show
    render :json => @location
  end

  private
    def set_company
      @company = Location.find_by_name(params[:name])
    end
end
