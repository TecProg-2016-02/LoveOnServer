class InteractionsController < ApplicationController
  def create
    interaction = Interaction.create(:user_one_id =>params[:user_one_id],:user_two_id => params[:user_two_id])
    if interaction.save
      render json: interaction
    end
  end
end
