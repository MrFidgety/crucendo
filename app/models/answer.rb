class Answer < ActiveRecord::Base
  
  belongs_to  :interaction
  belongs_to  :question
  belongs_to  :user
  
  validates :interaction_id,  presence: true
  validates :question_id,     presence: true
  validates :content,         length: { in: 23..3500, 
                              too_short: "that answer is a little short" }, 
                              :allow_nil => true

end