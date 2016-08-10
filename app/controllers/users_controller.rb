class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # skip_before_filter :verify_authenticity_token, :only => [:update]

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    end
  end

  def show
    user = User.find_by_token(params[:token])
    render :json => user
  end

  def all
    users = Array.new
    if(params[:male]=="true")
      u = User.where(:gender => "male")
      u.each { |e|
        users << e
      }
    end
    if(params[:female]=="true")
      t = User.where(:gender => "female")
      t.each { |e|
        users << e
      }
    end
    user = User.all
    render :json => user
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:confirm_token])
    if user
      user.email_activate
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end

  def update
    user = User.find_by_token(params[:token])
    if user
      if user.update(user_params)
        user.email_activate
        render json: user
      else
        render json: { error: 'Incorrect credentials' }, status: 401
      end
    end
  end

  def change_status
    if user.status==true
      user.stay_offline
    else
      user.stay_online
    end
  end

  private
  def set_user
    user = User.find_by_token(params[:token])
  end

  def user_params
    params.require(:user).permit(:name , :email, :id_facebook, :password,
      :password_confirmation, :gender, :avatar, :description,
      :birthday, :district, :city, :height, :width, :search_male, :search_female,
      :gallery => [])
  end

  def update_params
    params.require(:user).permit(:name , :gender, :avatar, :description,
    :birthday, :district, :city, :height, :width, :search_male, :search_female,
    :gallery => [])
  end
end
