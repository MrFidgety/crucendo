class Improvement < ActiveRecord::Base
  include Filterable
  
  belongs_to  :goal, :counter_cache => true
  belongs_to  :step
  has_one     :interaction
  
  default_scope -> { order(created_at: :desc) }
  scope :min_date, -> (date) { where("improvements.created_at >= ?", date.beginning_of_day) }
  scope :max_date, -> (date) { where("improvements.created_at <= ?", date.end_of_day) }
  scope :unexpected, -> (value) { where unexpected: value}
  
  validates :goal_id, presence: true
  validates_numericality_of :value, equal_to: 1
  
end
