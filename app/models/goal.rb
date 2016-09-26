class Goal < ActiveRecord::Base
  include Filterable
  extend Encryptable
  encrypt_columns :encrypted_goal
  
  belongs_to  :user
  has_many    :steps
  has_many    :improvements, dependent: :destroy
  has_one     :skill
  has_one     :interaction
  
  default_scope     -> { order(created_at: :desc) }
  scope :due_soonest, -> { order(due_date: :asc, created_at: :desc) }
  scope :active,      -> (value) { where(completed: false, active: value) }
  scope :completed,   -> (value) { where(completed: value) }
  scope :min_date,  -> (date) { where("created_at >= ?", date.beginning_of_day) }
  scope :max_date,  -> (date) { where("created_at <= ?", date.end_of_day) }
  
  validates :user_id,           presence: true
  validates :encrypted_goal,    presence: true, 
                                length: { maximum: 140 }
                      
  def has_improvement?(id)
    improvements.find_by(interaction_id: id)
  end
end