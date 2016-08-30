class Answer < ActiveRecord::Base
  
  belongs_to  :interaction
  belongs_to  :question
  belongs_to  :user
  
  validates :interaction_id,  presence: true
  validates :question_id,     presence: true
  validates :content,         length: { in: 5..3500, 
                              too_short: "that answer is a little short 
                              (minimum of 5 characters)" }, 
                              :allow_nil => true
                              
  scope :answered,     -> { where.not(content: nil) }

end