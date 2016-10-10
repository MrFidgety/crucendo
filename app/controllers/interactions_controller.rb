class InteractionsController < ApplicationController
  include Wicked::Wizard
  include InteractionsHelper
  
  before_action :find_interaction
  
  steps :begin, :q1, :q2, :q3, :haves, :wants, :feels, :crucendo
  
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
        skip_step
      else
        # Otherwise reset the answer value to plain text for display
        @answer.plain_encrypted_answer = params[:answer][:encrypted_answer]
      end
    elsif step.equal? :feels
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
        @interaction.update_attributes(interaction_params)
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
      # If first step, check if interaction already exists
      if step == :begin
        if @interaction = get_interaction(current_user)
          # Take user to next logical step if iteraction exists
          redirect_to wizard_path(:q1)
        end
      else
        # Find first incomplete interaction
        unless @interaction = get_interaction(current_user)
          if step == :q1
            # Build interaction if we are viewing q1
            @interaction = current_user.interactions.build
            # Redirect to root if interaction does not save
            redirect_to root_url if !@interaction.save 
          else
            # Redirect to begin step
            redirect_to wizard_path(Wicked::FIRST_STEP)
          end
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
