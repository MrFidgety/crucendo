class Answer < ActiveRecord::Base
  extend Encryptable
  encrypt_columns :encrypted_answer
  
  belongs_to  :interaction
  belongs_to  :question
  belongs_to  :user
  
  validates :interaction_id,  presence: true
  validates :question_id,     presence: true
  validates :encrypted_answer,  length: { in: 5..3500, 
                                too_short: "that answer is a little short 
                                (minimum of 5 characters)" }, 
                                :allow_nil => true
                              
  scope :answered,     -> { where.not(encrypted_answer: nil) }
  
  def answered?
    !encrypted_answer.blank?
  end

end