class GoalsController < ApplicationController
  include InteractionsHelper
  
  def create
    # create new goal from params
    @goal = current_user.goals.build(goal_params)
    
    # set interaction id, only if params includes interaction
    if params[:goal].try(:has_key?, :interaction_id)
      @goal.interaction_id = get_interaction(current_user).id 
    end
    
    # response allows for ajax calls
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
  
  def improve
    @goal = Goal.find(params[:id])
    
    # set interaction id, only if params includes interaction
    if params.has_key?(:interaction_id)
      # check if improvement already exists
      @interaction = Interaction.find(params[:interaction_id])
      
      if @improvement = @goal.improvements.find_by(interaction_id: params[:interaction_id])
        @improvement.destroy
      else
        @improvement = @goal.improvements.build
        @improvement.interaction_id = get_interaction(current_user).id 
      end
    else
      @improvement = @goal.improvements.build
    end
    
    respond_to do |format|
      if @improvement.save
        format.html { redirect_to @improvement.goal }
        format.js
      else
        format.html { redirect_to @improvement.goal }
        format.json { render json: @improvement.errors, status: :unprocessable_entity }
        format.js   { render json: @improvement.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
    def goal_params
      if !params[:goal][:due_date_utc].blank?
        params[:goal][:due_date] = params[:goal][:due_date_utc]
      end
      params.require(:goal).permit( :content, 
                                    :due_date, 
                                    :completed_date, 
                                    :active)
    end
end
