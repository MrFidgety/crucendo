class Answer < ActiveRecord::Base
  
  belongs_to  :interaction
  has_one     :question
  
  validates :interaction_id,  presence: true
  validates :question_id,     presence: true
  validates :content,         presence: true,
                              length: { maximum: 3500 }
  
end