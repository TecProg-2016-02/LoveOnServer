class InteractionsController < ApplicationController
  def create
    interaction = Interaction.create(:user_one_id =>params[:user_one_id],
      :user_two_id => params[:user_two_id], :like => params[:like])
    if interaction.save
      render json: interaction, :methods => [:match]
    end
  end
end
