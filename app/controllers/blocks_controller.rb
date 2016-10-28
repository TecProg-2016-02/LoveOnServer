class BlocksController < ApplicationController

  def create
    #This part of code permit the user block another user
    block = Block.create(:user_one_id => params[:user_one_id],
      :user_two_id => params[:user_two_id])
    if block.save
      render json: block
    end
  end

  def destroy
    #This part of code permit the user unlock another user
    block = Block.where(:user_one_id => params[:user_one_id],
      :user_two_id => params[:user_two_id]).first
    block.delete
  end
end
