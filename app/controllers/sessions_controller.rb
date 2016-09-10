class SessionsController < ApplicationController
    # skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user.nil?
      user = User.find_by_id_social(params[:id_social])
    end
    if user.authenticate(params[:password])
      blocked_ids = Array.new
      user.block_one.each { |t|
        blocked_ids << t.user_two_id
      }
      cookies[:token] = user.token
      current_user = User.find_by_token!(cookies[:token]) if cookies[:token]
      # .includes(:following)
      #   .where.not(following: { id: [blocked_ids]})
      # current_user.following.includes(:following).where.not(following: { id: [blocked_ids]})
      # current_user.followers.includes(:followers).where.not(followers: { id: [blocked_ids]})
      current_user.stay_online
      render :json => current_user, :include =>[:locations, :location, :followers, :following],
        :methods => [:matches, :matches_token, :age, :interactions_one, :blocks, :user_follows, :follow_user]
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
