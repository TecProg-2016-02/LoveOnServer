class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
skip_before_filter :verify_authenticity_token, :only => [:update]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    end
  end

  def show
    render :json => @user.to_json(:include => :companies )
  end

  private
  def set_user
    @user = User.find_by_token(params[:token])
  end
  def user_params
    params.require(:user).permit(:name , :email, :id_facebook, :password,
      :password_confirmation)
  end

end
