class BlocksController < ApplicationController

  def create
    #This part of code permit the user block another user
    block = Block.create(:first_user_interaction_id => params[:first_user_interaction_id],
      :user_two_id => params[:user_two_id])
    if block.save
      render json: block
    else
      # do nothing
    end
  end

  def destroy
    #This part of code permit the user unlock another user
    block = Block.where(:first_user_interaction_id => params[:first_user_interaction_id],
      :user_two_id => params[:user_two_id]).first
    block.delete
  end
end
