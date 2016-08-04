class Interaction < ActiveRecord::Base
  
  belongs_to  :user
  has_many    :answers, dependent:  :destroy
  has_many    :goals
  has_many    :improvements
  
  before_create :assign_question_answers
  
  validates :user_id, presence: true
  
  # find first linked answer that is incomplete
  def find_next_answer
    answers.where(:content => nil).first
  end
  
  # set interaction as completed
  def complete
    update_attribute(:completed, true)
  end
  
  private
  
    # assign questions to interaction
    def assign_question_answers
      @questions = Question.order("RANDOM()").limit(3)
      @questions.each do |question|
        answers.build(question_id: question.id)
      end
    end

end
