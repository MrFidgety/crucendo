class InteractionsController < ApplicationController
  include Wicked::Wizard
  
  before_action :find_interaction
  
  steps :questions, :want_to_improve, :have_improved
  
  def show
    # when at questions step, determine which question to show
    if step == :questions
      @answer = @interaction.find_next_answer
      
      if @answer == nil 
        skip_step
      end
    end
    
    render_wizard
  end
  
  def update
    
    if step == :questions
      @interaction.find_next_answer.update_attributes(answer_params)
      @answer = @interaction.find_next_answer
      
      if @answer == nil 
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
      @interaction = current_user.interactions.find_by(completed: false) ||
                        current_user.interactions.build
      if !@interaction.save 
        redirect_to root_url
      end
    end
    
    def answer_params
      params.require(:answer).permit(:content)
    end
end
