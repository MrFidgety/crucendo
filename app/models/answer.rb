class Answer < ActiveRecord::Base
  
  belongs_to  :interaction
  belongs_to  :question
  
  validates :interaction_id,  presence: true
  validates :question_id,     presence: true
  validates :content,         length: { maximum: 3500 }
  
end