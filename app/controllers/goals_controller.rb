class GoalsController < ApplicationController
  
  def create
    @goal = current_user.goals.build(goal_params)
    
    respond_to do |format|
      if @goal.save
        format.html { redirect_to @goal }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
        format.js   { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
    def goal_params
      params.require(:goal).permit(:content, :due_date, :completed_date, :active)
    end
end
