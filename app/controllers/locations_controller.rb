class LocationsController < ApplicationController
=begin
  Geokit provides key functionality for location-oriented Rails applications: in here we use for distance calculations.
=end

  def index
    # will capture the location
    origin = Geokit::LatLng.new(params[:latitude],params[:longitude])
    # 3.5 is the search distance
    locations = Location.within(3.5, :origin => origin)
    # will pass the information in json format
    render :json => locations
  end

=begin
  In the current version of geokit-rails, it is not possible to add a where clause using the distance column. The only way to do this, is below.
=end

  def all
    # will consult all the locations
    locations = Location.all
    # will pass the information in json format
    render :json => locations
  end

  def show
    # will show the user by his token
    user = User.find_by_token(params[:user_token])
    # create an array for blocked people
    blocked_ids = Array.new
    # create an table of blocked users
    user.block_one.each { |t|
      blocked_ids << t.user_two_id
    }
    # female gender
    if user.search_male == true && user.search_female == false
      # will find in the chosen place the male gender
      location = Location.includes(:users).where('users.gender = ?', 'male')
        # will search the user by his age and tokens
        .where("users.age <= ?", user.search_range).where(token: params[:token])
        # will consult the user on database
        .where.not(users: { id: user.id })
        # will consult the blocked users on database
        .where.not(users: { id: [blocked_ids]})
      # will render the informations on json format
      render :json => location.first, :include => [:users]

    # male gender
    elsif user.search_male == false && user.search_female == true
      # will find in the chosen location the female gender
      location = Location.includes(:users).where('users.gender = ?', 'female')
        # search the user by his age and tokens
        .where("users.age <= ?", user.search_range).where(token: params[:token])
        # will consult the users on database
        .where.not(users: { id: user.id })
        # will consult the blocked users
        .where.not(users: { id: [blocked_ids]})
      # will render the informations in json format
      render :json => location.first, :include => [:users]

    else
      # will include the users in the locations
      location = Location.includes(:users)
        # will search user by age and tokens
        .where("users.age <= ?", user.search_range).where(token: params[:token])
        # will consult the user
        .where.not(users: { id: user.id })
        # will consult the blocked users
        .where.not(users: { id: [blocked_ids]})
      # will render the informations in json format
      render :json => location.first, :include => [:users]
    end
  end

  private
    # define a company
    def set_company
      # will permit to find a place by his name
      location = Location.find_by_name(params[:name])
    end
end
