class SessionsController < ApplicationController
    # skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user.authenticate(params[:password])
      cookies[:token] = user.token
      current_user = User.find_by_token!(cookies[:token]) if cookies[:token]
      current_user.stay_online
      render :json => current_user, :include =>[:locations, :location, :followers, :following], :methods => [:matches, :matches_token, :age, :interactions_one]
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end

  def destroy
    user = User.find_by_email(params[:email])
    cookies.delete(:token)
    if user
      user.stay_offline
      render :json => user, :include =>[:locations], :methods => [:matches, :matches_token, :age, :last_place]
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end

end
