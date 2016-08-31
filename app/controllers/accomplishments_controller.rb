class AccomplishmentsController < ApplicationController
  
  before_action :set_current_user
  
  def index
    # Get list of users interactions
    @interactions = @user.interactions.completed
  end
end
