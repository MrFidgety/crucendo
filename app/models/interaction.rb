class Interaction < ActiveRecord::Base
  
  belongs_to  :user
  has_many    :answers
  
  validates :user_id, presence: true
  
end
