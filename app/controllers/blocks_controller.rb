class BlocksController < ApplicationController
  def create
    block = Block.create(:user_one_id =>params[:user_one_id],
      :user_two_id => params[:user_two_id])
    if block.save
      render json: interaction
    end
  end
end
