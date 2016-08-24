class ImprovementsController < ApplicationController
  
  before_action :logged_in_user
  
  def index
    @improvements = current_user.improvements.paginate(page: params[:page], :per_page => 10)
  end
end