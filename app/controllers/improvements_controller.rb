class ImprovementsController < ApplicationController
  
  before_action :set_current_user
  before_action :correct_user,  except: :index
  before_action :validate_search, only: :index
  
  # Prevent flash from appearing twice after AJAX call
  after_filter { flash.discard if request.xhr? }
  
  def index
    @goal = Goal.new
    @goal.active = false
    
    # Get list of improvements filtered with params
    @improvements = @user.improvements.includes(:goal).filter(
                        params.slice(:min_date, :max_date, :unexpected))
                        .paginate(:per_page => 10, :page => params[:page])
  end
  
  def destroy
    @improvement.destroy
    # Set flash to notify user of successful delete
    set_flash :have_deleted, type: :success, object: @improvement  
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
    
    def validate_search
      params[:min_date] = Time.zone.parse(params[:min_date]) if params.has_key?(:min_date)
      params[:max_date] = Time.zone.parse(params[:max_date]) if params.has_key?(:max_date)
      # Unable to pass 'false' as present? in filter ignores it, using 1/0 instead
      unless params.has_key?(:unexpected) && ['1','0'].include?(params[:unexpected])
        params.delete :unexpected
      end
    end
end