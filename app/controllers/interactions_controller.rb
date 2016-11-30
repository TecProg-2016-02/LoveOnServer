class InteractionsController < ApplicationController

  def create
    # create an interations between two users
    interaction = Interaction.create(:first_user_interaction_id =>params[:first_user_interaction_id],
      :user_two_id => params[:user_two_id], :like => params[:like])
    # save that interaction that was made
    if interaction.save
      # if the interaction was done correctly will send the information in json format 
      render json: interaction, :methods => [:match]
    end
  end
end
