class Improvement < ActiveRecord::Base
  
  belongs_to  :goal, :counter_cache => true
  belongs_to  :step
  has_one     :interaction
  
  default_scope -> { order(created_at: :desc) }
  
  validates :goal_id, presence: true
  validates_numericality_of :value, equal_to: 1
  
end
