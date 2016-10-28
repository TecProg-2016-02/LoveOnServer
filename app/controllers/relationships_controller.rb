class RelationshipsController < ApplicationController

  def create
    # the main user will be find by the params required
    main_user = User.find_by_token(params[:main_user_auth_token])
    # the user will be found for the parameters used
    user = User.find_by_token(params[:token])
    # the user will be able to follow the find user
    main_user.follow(user)
  end

  def destroy
    # the main user will search the user
    main_user = User.find_by_token(params[:main_user_auth_token])
    # the main user will find the another user
    user = User.find_by_token(params[:token])
    # the main user will unfollow the another user
    main_user.unfollow(user)
  end
end
