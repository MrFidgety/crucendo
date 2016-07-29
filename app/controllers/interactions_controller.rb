class InteractionsController < ApplicationController
  include Wicked::Wizard
  
  before_action :find_interaction
  before_action :answer_current,  only: :update
  
  steps :questions, :have_improved, :want_to_improve, :crucendo
  
  def show
    
    case step
      when :questions
        # set answer if on questions step  
        @answer = @interaction.find_next_answer 
        # move to next step if no "next answer"
        skip_step if @answer.blank?
      when :want_to_improve
        @goal = Goal.new
    end
    
    render_wizard
  end
  
  def update
    
    if step.equal? :questions
      # if answer saves, move to next unanswered question
      @answer = @interaction.find_next_answer if @answer.update_attributes(
                                                                  answer_params)
      # move to next step if no "next answer"
      skip_step if @answer.blank?
    end

    render_wizard
  end
  
  private

    def redirect_to_finish_wizard(id)
      @interaction.complete
      redirect_to root_url
    end
    
    def find_interaction
      # find first incomplete interaction, or create one
      @interaction = current_user.interactions.find_by(completed: false) ||
                        current_user.interactions.build
      
      # redirect to root if interaction does not save
      redirect_to root_url if !@interaction.save 
      
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
