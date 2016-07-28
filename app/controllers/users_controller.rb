class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
skip_before_filter :verify_authenticity_token, :only => [:update]

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      render json: @user
    end
  end

  def show
    render :json => @user.to_json(:include => :companies )
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:confirm_token])
    if user
      user.email_activate
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
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
