class ImprovementsController < ApplicationController
  
  before_action :set_current_user
  
  def index
    @improvements = @user.improvements.paginate(
                      page: params[:page], :per_page => 10)
  end
end