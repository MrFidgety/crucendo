class Step < ActiveRecord::Base
  
  belongs_to :goal
  
  default_scope -> { order(order: :asc) }
  
  validates :goal_id, presence: true
  validates :content, presence: true, 
                      length: { maximum: 140 }
                      
end
