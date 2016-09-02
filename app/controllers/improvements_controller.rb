class ImprovementsController < ApplicationController
  
  before_action :set_current_user
  
  def index
    @improvements = @user.improvements
  end
end