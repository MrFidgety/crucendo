class GoalsController < ApplicationController
  include InteractionsHelper
  
  before_action :set_current_user
  before_action :correct_user,  except: [:index, :create, :unexpected]
  before_action :validate_search, only: :index
  
  # Prevent flash from appearing twice after AJAX call
  after_filter { flash.discard if request.xhr? }
  
  def index
    @goal = Goal.new
    @goals = @user.goals.most_recent.filter(
                        params.slice(:min_date, :max_date, :active, :completed))
                        .paginate(:per_page => 10, :page => params[:page])
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
        format.js { @type = params[:goal].try(:has_key?, :interaction_id) ? 'interaction' : 'standard'}
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
    # Link to interaction if there is an interaction parameter
    if params[:goal].try(:has_key?, :interaction_id)
      # Interaction id is found from currently incomplete interaction
      @goal.interaction_id = get_interaction(@user).id 
    end
    # Respond to AJAX call
    respond_to do |format|
      if @goal.save
        # Set flash to notify user of success
        set_flash :want_added, type: :success   
        format.html { redirect_to @goal }
        # Include variable to determine if this came from an interaction
        format.js   { @type = @goal.interaction_id ? 'interaction' : 'improvement' }
      else
        format.html { render action: 'new' }
        format.js   { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def unexpected
    # Create new goal from params
    @goal = @user.goals.build(goal_params)
    # Link to interaction if there is an interaction parameter
    if params[:goal].try(:has_key?, :interaction_id)
      # Interaction id is found from currently incomplete interaction
      @goal.interaction_id = get_interaction(@user).id
    end
    # Respond to AJAX call
    respond_to do |format|
      if @goal.save
        # Create improvement if goal saves
        @improvement = @goal.improvements.create(unexpected: true, 
                        interaction_id: @goal.interaction_id)
        # Set flash to notify user of success
        set_flash :have_added, type: :success           
        format.html { redirect_to @improvement.goal }
        # Include variable to determine if this came from an interaction
        format.js   { @type = @goal.interaction_id ? 'interaction' : 'improvement' }
      else
        format.html { render action: 'new' }
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
        # Set to unexpected if goal was created this interaction
        @improvement.unexpected = true if @goal.interaction_id == @interaction.id
        # Set flash to notify user of success
        set_flash :have_added, type: :success   
      end
    else
      # Create new basic improvement (with no linked interaction)
      @improvement = @goal.improvements.build(improvement_params)
      # Set flash to notify user of success
      set_flash :have_added, type: :success   
    end
    # Response allows for ajax calls
    respond_to do |format|
      if @improvement.save
        format.html { redirect_to @improvement.goal }
        # Include variable to determine if this came from an interaction
        format.js   { @type = @interaction ? 'interaction' : 'improvement' }
      else
        format.html { redirect_to @improvement.goal }
        format.json { render json: @improvement.errors, status: :unprocessable_entity }
        format.js   { render json: @improvement.errors, status: :unprocessable_entity }
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
      if params[:goal][:due_date_utc].present? && current_user.time_zone.blank?
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
    
    def improvement_params
      # Perform date calculation if date set
      if params[:improvement_date].present?
        if params[:improvement_date_utc].present? && current_user.time_zone.blank?
          # Use javascript UTC date if user hasn't set timezone
          params[:created_at] = params[:improvement_date_utc]
        else
          # Use middle of day on date selected by user
          params[:created_at] = Time.zone.parse(params[:improvement_date]).middle_of_day
        end
      end
      params.permit(:created_at)
    end
    
    def correct_user
      # Ensure goal belongs to current user
      redirect_to root_url unless @goal = @user.goals.find_by(id: params[:id])
    end
    
    def validate_search
      params[:min_date] = Time.zone.parse(params[:min_date]) if params.has_key?(:min_date)
      params[:max_date] = Time.zone.parse(params[:max_date]) if params.has_key?(:max_date)
      case params[:status]
      when 'complete'
        params[:completed] = true
      when 'active'
        params[:active] = '1'
      when 'inactive'
        params[:active] = '0'
      end
    end
end
