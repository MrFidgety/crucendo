class GoalsController < ApplicationController
  include InteractionsHelper
  
  def index
    @goals = current_user.goals.recently_created
  end
  
  def show
    @goal = Goal.find(params[:id])
    @improvements = @goal.improvements
  end
  
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
      @interaction = get_interaction(current_user)
      
      if @improvement = @goal.improvements.find_by(interaction_id: @interaction.id)
        # delete improvement
        @improvement.destroy
        # reload goal to update counter cache
        @goal.reload
      else
        # create new improvement linked to interaction
        @improvement = @goal.improvements.build(interaction_id: @interaction.id)
      end
    else
      # create new basic improvement
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
  
  def unexpected
    
    @interaction = get_interaction(current_user)
    @goal = current_user.goals.build(goal_params)
    @goal.attributes = { interaction_id: @interaction.id }
    @goal.attributes = { completed_date: Time.zone.now } if @goal.completed?
    
    respond_to do |format|
      if @goal.save
        @improvement = @goal.improvements.build(
            interaction_id: @interaction.id,
            unexpected: true)
        @improvement.save
        
        format.html { redirect_to @improvement.goal }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
        format.js   { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    
    respond_to do |format|
      format.html { redirect_to goals_path }
      format.js 
    end
  end
  
  private
  
    def goal_params
      if !params[:goal][:due_date_utc].blank?
        params[:goal][:due_date] = params[:goal][:due_date_utc]
      end
      params.require(:goal).permit( :content, 
                                    :due_date, 
                                    :completed, 
                                    :active)
    end
    
end
