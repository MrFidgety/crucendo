class ImprovementsController < ApplicationController
  
  before_action :set_current_user
  before_action :correct_user,  except: [:index]
  
  def index
    @improvements = @user.improvements
    @goal = Goal.new
    @goal.active = false
  end
  
  def destroy
    @improvement.destroy
    respond_to do |format|
      format.html { redirect_to improvements_path }
      format.js 
    end
  end
  
  private
    def correct_user
      # Ensure improvement belongs to current user
      redirect_to root_url unless @improvement = @user.improvements
                                                  .find_by(id: params[:id])
    end
end