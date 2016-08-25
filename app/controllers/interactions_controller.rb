class InteractionsController < ApplicationController
  include Wicked::Wizard
  include InteractionsHelper
  
  before_action :find_interaction
  before_action :correct_step,    only: :show
  before_action :answer_current,  only: :update
  
  steps :begin, :questions, :have, :want, :feeling, :crucendo
  
  def show
    
    case step
      when :questions
        @answer = @interaction.find_next_answer
        skip_step if @answer.blank?
      when :have
        @goal = Goal.new
        @goals = current_user.goals.includes(:improvements)
          .where('(active = ? AND completed = ?) OR interaction_id = ?', 'true', 'false', @interaction.id)
      when :want
        @goal = Goal.new
        @goals = @interaction.goals.where(completed: false)
      when :crucendo
        @interaction.complete
    end
    
    render_wizard
  end
  
  def update
    
    if step.equal? :questions
      # if answer saves, move to next unanswered question
      if @answer.update_attributes(answer_params)
        @answer = @interaction.find_next_answer
      end
      
      # move to next step if no "next answer"
      skip_step if @answer.blank?
    end
    
    if step.equal? :feeling
      @interaction.update_attributes(interaction_params)
      skip_step
    end
    
    render_wizard
  end
  
  private

    def redirect_to_finish_wizard(id)
      redirect_to root_url
    end
    
    def find_interaction
      # find first incomplete interaction, or create one
      @interaction = get_interaction(current_user) || current_user.interactions.build
      
      # redirect to root if interaction does not save
      redirect_to root_url if !@interaction.save 
    end
    
    def correct_step
      answered = @interaction.answers.answered.size
      case step
        when :begin
          # ok if no questions answered
          if answered != 0
            if answered == 3
              redirect_to wizard_path(:have)
            else
              redirect_to wizard_path(:questions)
            end
          end
        when :questions
          redirect_to wizard_path(:have) if answered == 3
        else
          redirect_to wizard_path(:questions) if answered < 3
      end
    end
    
    def answer_current
      if step.equal? :questions
        # find answer
        @answer = current_user.answers.find_by_id(params[:answer][:id].to_i)
        
        if @answer.blank?
          # set flash notice advising issue answering question
          redirect_to root_url
        end
        
        if !@answer.content.blank?
          # set flash notice advising question already answered
          set_flash :question_already_answered, type: :info
          redirect_to wizard_path(:questions)
        end

      end
    end
    
    def answer_params
      params.require(:answer).permit(:content)
    end
    
    def interaction_params
      params.require(:interaction).permit(:feeling, :journal)
    end
end
