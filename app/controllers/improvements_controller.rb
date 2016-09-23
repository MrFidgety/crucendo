class ImprovementsController < ApplicationController
  
  before_action :set_current_user
  before_action :correct_user,  except: :index
  before_action :validate_dates, only: :index
  
  def index
    @improvements = @user.improvements.filter(
                        params.slice(:min_date, :max_date, :unexpected))
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
    
    def validate_dates
      params[:min_date] = Time.zone.parse(params[:min_date]) if params.has_key?(:min_date)
      params[:max_date] = Time.zone.parse(params[:max_date]) if params.has_key?(:max_date)
      # Unable to pass 'false' as present? in filter ignores it, using 1/0 instead
      params[:unexpected] =  params[:unexpected] == 'true' ? '1' : '0' if params.has_key?(:unexpected)
    end
end