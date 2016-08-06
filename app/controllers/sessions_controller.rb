class SessionsController < ApplicationController
    # skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user.authenticate(params[:password])
      cookies[:token] = user.token
      @current_user = User.find_by_token!(cookies[:token]) if cookies[:token]
      render :json => @current_user, :include =>[:locations], :methods => [:matches, :matches_token, :age]
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end
  def destroy
    cookies.delete(:token)
  end
end
