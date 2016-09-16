class GoalsController < ApplicationController
  include InteractionsHelper
  
  before_action :set_current_user
  before_action :correct_user,  except: [:index, :create, :unexpected]
  
  def index
    # Get lists of each goal status
    @active_goals = @user.goals.active_most_recent
    @inactive_goals = @user.goals.inactive
    @completed_goals = @user.goals.completed
  end
  
  def show
    # Get a list of this goals improvements
    @improvements = @goal.improvements
  end
  
  def update
    if @goal.update_attributes(goal_params)
      set_flash :good_button, type: :success
      respond_to do |format|
        format.html { redirect_to goal_path(@goal) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js   { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create
    # Create new goal from params
    @goal = @user.goals.build(goal_params)
    # Set interaction id, only if params includes interaction
    if params[:goal].try(:has_key?, :interaction_id)
      # Interaction id is found from currently incomplete interaction
      @goal.interaction_id = get_interaction(@user).id 
    end
    # Response allows for ajax calls
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
    # Set interaction id, only if params includes interaction
    if params.has_key?(:interaction_id)
      # Find users current interaction
      @interaction = get_interaction(@user)
      # Check if improvement already exists
      if @improvement = @goal.improvements.find_by(interaction_id: @interaction.id)
        # Delete improvement
        @improvement.destroy
        # Reload goal to update improvement counter cache
        @goal.reload
      else
        # Create new improvement linked to interaction
        @improvement = @goal.improvements.build(interaction_id: @interaction.id)
      end
    else
      # Create new basic improvement (with no linked interaction)
      @improvement = @goal.improvements.build
    end
    # Response allows for ajax calls
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
    # Find users current interaction
    @interaction = get_interaction(@user)
    # Create new goal
    @goal = @user.goals.build(goal_params)
    @goal.attributes = { interaction_id: @interaction.id }
    @goal.attributes = { completed_date: Time.zone.now } if @goal.completed?
    # Response allows for ajax calls
    respond_to do |format|
      if @goal.save
        # Create improvement if goal saves
        @improvement = @goal.improvements.create(
                          interaction_id: @interaction.id,
                          unexpected: true)
        format.html { redirect_to @improvement.goal }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
        format.js   { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def complete
    # set/unset goals as complete (ajax call from 'have' page)
  end
  
  def destroy
    @goal.destroy
    respond_to do |format|
      format.html { redirect_to goals_path }
      format.js 
    end
  end
  
  private
  
    def goal_params
      # Only use javascript UTC date if user hasn't set timezone
      if !params[:goal][:due_date_utc].blank? && current_user.time_zone.blank?
        params[:goal][:due_date] = params[:goal][:due_date_utc]
      end
      case params[:status]
      when 'complete'
        unless @goal.completed?
          params[:goal][:active] = false
          params[:goal][:completed] = true
          params[:goal][:completed_date] = Time.zone.now
        end
      when 'active'
        params[:goal][:active] = true
        if @goal.completed?
          params[:goal][:completed] = false
          params[:goal][:completed_date] = nil
        end
      when 'inactive'
        params[:goal][:active] = false
        if @goal.completed?
          params[:goal][:completed] = false
          params[:goal][:completed_date] = nil
        end
      end
      params.require(:goal).permit(:encrypted_goal, :due_date, :completed, 
                                    :completed_date, :active)
    end
    
    def correct_user
      # Ensure goal belongs to current user
      redirect_to root_url unless @goal = @user.goals.find_by(id: params[:id])
    end
end
