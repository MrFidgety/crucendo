class Interaction < ActiveRecord::Base
  
  belongs_to  :user
  has_many    :answers, dependent:  :destroy
  
  before_create :assign_question_answers
  
  validates :user_id, presence: true
  
  # find first linked answer that is incomplete
  def find_next_answer
    answers.where(:content => nil).first
  end
  
  private
  
    def assign_question_answers
      @questions = Question.take(3)
      @questions.each do |q|
        answers.build(question_id: q.id)
      end
    end

end
