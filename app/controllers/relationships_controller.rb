class RelationshipsController < ApplicationController
  def create
    main_user = User.find_by_token(params[:main_user_auth_token])
    user = User.find_by_token(params[:token])
    main_user.follow(user)
  end

  def destroy
    main_user = User.find_by_token(params[:main_user_auth_token])
    user = User.find_by_token(params[:token])
    main_user.unfollow(user)
  end
end
