class BlocksController < ApplicationController
  def create
    block = Block.create(:user_one_id =>params[:user_one_id],
      :user_two_id => params[:user_two_id])
    if block.save
      render json: block
    end
  end
  def destroy
    block = Block.where(:user_one_id =>params[:user_one_id],
      :user_two_id => params[:user_two_id]).first
    block.delete
  end
end
