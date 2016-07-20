class Step < ActiveRecord::Base
  
  belongs_to :goal
  
  validates :goal_id, presence: true
  validates :content, presence: true, 
                      length: { maximum: 140 }
                      
end
