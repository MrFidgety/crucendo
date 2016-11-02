class InteractionsController < ApplicationController
  include Wicked::Wizard
  include InteractionsHelper
  
  before_action :find_interaction
  
  steps :q1, :q2, :q3, :haves, :wants, :finish, :crucendo
    
  # Prevent flash from appearing twice after answer update
  after_filter { flash.discard if [:q1, :q2, :q3].include? step }
  
  def show
    case step
      # Retrieve answer
      when :q1
        @answer = @interaction.answers.order(:id).first
      when :q2
        @answer = @interaction.answers.order(:id).second
      when :q3
        @answer = @interaction.answers.order(:id).third
      when :haves
        # Set up new goal and set to inactive by default
        @goal = Goal.new
        @goal.active = false
        # Find all current active goals, plus those linked to this interaction
        @active_goals = current_user.goals.includes(:improvements)
          .where('active = ? AND completed = ? AND interaction_id != ?', 
          'true', 'false', @interaction.id).order('improvements_count asc')
        @interaction_goals = current_user.goals.includes(:improvements)
          .where('interaction_id = ?', @interaction.id).order('created_at desc')
        @goals = @interaction_goals + @active_goals
        @goals = current_user.goals.active(true)
      when :wants
        # Set up new goal
        @goal = Goal.new
        # Find all goals linked to this interaction that are active
        @goals = @interaction.goals.active(true).order('created_at desc')
      when :crucendo
        # Set this interaction to complete
        @interaction.complete
    end
    render_wizard
  end
  
  def update
    # If question is being answered
    if [:q1, :q2, :q3].include? step
      # Get current answer
      case step
        when :q1
          @answer = @interaction.answers.order(:id).first
        when :q2
          @answer = @interaction.answers.order(:id).second
        when :q3
          @answer = @interaction.answers.order(:id).third
      end
      # Try to update answer
      if @answer.update_attributes(answer_params)
        # Move to next step if answer saves
        params.has_key?(:follow) ? (return redirect_to(params[:follow])) : skip_step
      else
        # Otherwise reset the answer value to plain text for display
        @answer.plain_encrypted_answer = params[:answer][:encrypted_answer]
        # Alert user that criteria must be met
        set_flash :something_missing, type: :warning
      end
    elsif step.equal? :finish
      # Set crucendo feelings
      @interaction.update_attributes(interaction_params)
      # Check if all questions have been answered
      if @answer = @interaction.missing_answers
        # Alert user that criteria must be met
        set_flash :answer_required, type: :warning
        # Take user to specific step
        if @answer == @interaction.answers.order(:id).first
          jump_to(:q1)
        elsif @answer == @interaction.answers.order(:id).second
          jump_to(:q2)
        else
          jump_to(:q3)
        end
      else
        skip_step
      end
    end
    render_wizard
  end
  
  private

    def redirect_to_finish_wizard(id)
      redirect_to root_url
    end
    
    def find_interaction
      # Find first incomplete interaction
      unless @interaction = get_interaction(current_user)
        if step == :q1
          # Build interaction if we are viewing q1
          @interaction = current_user.interactions.build
          # Redirect to root if interaction does not save
          redirect_to root_url if !@interaction.save 
        else
          # Redirect to first step
          redirect_to wizard_path(Wicked::FIRST_STEP)
        end
      end
    end
    
    def answer_params
      params.require(:answer).permit(:encrypted_answer)
    end
    
    def interaction_params
      params.require(:interaction).permit(:feeling, :journal)
    end
end
