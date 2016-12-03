class SessionsController < ApplicationController
    # skip_before_action :authorize

  def new
  end

  def create
    # This part will create a user
    if (params[:id_social] == nil || params[:password] == nil)
      render json: { error: 'Null user input'}, status: 401
    else
        user = User.find_by_id_social(params[:id_social])
    end

    # This part will check if the user is with the correct password, will show who the user is blocked. If the password of the user has the wrong password, it will show error 401
    if user.authenticate(params[:password])
      blocked_ids = Array.new
      user.who_blocks.each { |t|
        blocked_ids << t.user_two_id
      }
      cookies[:token] = user.token
      current_user = User.find_by_token!(cookies[:token]) if cookies[:token]
      current_user.stay_online
      render :json => current_user, :include =>[:locations, :location, :followers, :following],
        :methods => [:matches, :matches_token, :age, :interactions_one, :blocks, :user_follows, :follow_user]
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end

  def destroy
    # This part will check if the user is null, if it will present the error 401. Otherwise the user will be found by the id
    if (params[:email] == nil || params[:token] == nil)
      render json: { error: 'Null email'}, status: 401
    else
      user = User.find_by_email(params[:email])
      cookies.delete(:token)
    end

    # This part will check if the user is offline and save your information, if you have any wrong information it will display error 401
    if user
      user.stay_offline
      render :json => user, :include =>[:locations], :methods => [:matches, :matches_token, :age, :last_place]
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end

end
