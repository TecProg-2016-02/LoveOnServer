class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # skip_before_filter :verify_authenticity_token, :only => [:update]

  # this part of code will create an user
  def create
    user = User.new(user_params)
    # save the informations given by the user, if it is valid render in json format, if isn't valid will render an error and show to the user where is the mistake
    if user.save
      render json: user
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end

  # this part will show the user informations, like who is following, who gave match, etc
  def show
    current_user = User.find_by_token(params[:current_user_token])
    user = User.find_by_token(params[:token])
    is_following = current_user.following?(user)
    matched = current_user.matched?(user)
    blocked = current_user.blocked?(user)

    render :json => {
      :user => user,:locations => user.locations,
      :is_following => is_following, :matched => matched,
      :blocked => blocked
    }
  end

  # this part of code will confirm the user email
  def confirm_email
    user = User.find_by_confirm_token(params[:confirm_token])
    # if the email is valid, the user will receive notifications of the app, if the email isn't valid will show the error to the user
    if user
      user.email_activate
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end

  # this bloc of code will apdate all the date of the user
  def update
    user = User.find_by_token(params[:token])
    if user
      user.age
      user.gallery_will_change!
      # if the new data insert is valid, it will be saved, if isn't will show the error message
      if user.update(update_params)
        user.email_activate
        render json: user
      else
        render json: { error: 'Incorrect credentials' }, status: 401
      end
    end
  end

  # this part wil inform the status of the user
  def change_status
    # if the user isn't in the app his status will be offline, if the user is accessing the app, his status will be online
    if user.status == true
      user.stay_offline
    else
      user.stay_online
    end
  end

  # all these informations are private, and cannot be altered
  private
  # will attribute the informations for the user
  def set_user
    user = User.find_by_token(params[:token])
  end

  # the app require these informations for the user to register in the app
  def user_params
    params.require(:user).permit(:name , :email, :password,
      :password_confirmation, :gender, :avatar, :description, :background,
      :birthday, :district, :city, :height, :weight, :search_male, :search_female,
      :search_range, :id_social, :gallery => [])
  end

  # these params are used for update the data of the user
  def update_params
    params.require(:user).permit(:name , :gender, :avatar, :description, :background,
    :birthday, :district, :city, :height, :weight, :search_male, :search_female,
    :search_range, :id_social, :gallery => [])
  end
end
