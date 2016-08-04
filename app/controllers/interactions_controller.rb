class InteractionsController < ApplicationController
  include Wicked::Wizard
  include InteractionsHelper
  
  before_action :find_interaction
  before_action :needs_answers,   only: :show
  before_action :answer_current,  only: :update
  
  steps :questions, :have, :want, :crucendo
  
  def show
    
    case step
      when :questions
        @answer = @interaction.find_next_answer
        skip_step if @answer.blank?
      when :have
        @goals = current_user.goals
      when :want
        @goal = Goal.new
        @goals = @interaction.goals
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
    
    def needs_answers
      # find first unanswered question
       redirect_to interactions_path if @answer = @interaction.find_next_answer unless step.equal? :questions
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
          
          redirect_to root_url
        end

      end
    end
    
    def answer_params
      params.require(:answer).permit(:content)
    end
end
