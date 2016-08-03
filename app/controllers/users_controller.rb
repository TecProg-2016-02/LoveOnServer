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
    render :json => @user
  end

  def all
    users = Array.new
    if(params[:male]=="true")
      u = User.where(:gender => "Masculino")
      u.each { |e|
        users << e
      }
    end
    if(params[:female]=="true")
      t = User.where(:gender => "Feminino")
      t.each { |e|
        users << e
      }
    end

    render :json => users
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
      :password_confirmation, :gender, :gallery, :avatar, :description)
  end

end
