class Goal < ActiveRecord::Base
  extend Encryptable
  encrypt_columns :encrypted_goal
  
  belongs_to  :user
  has_many    :steps
  has_many    :improvements, dependent: :destroy
  has_one     :skill
  has_one     :interaction
  
  scope :due_soonest,         -> { order(due_date: :asc, created_at: :desc) }
  scope :active,              -> { where(completed: false, active: true) }
  scope :active_most_recent,  -> { active.order(created_at: :desc) }
  scope :inactive,            -> { where(active: false, completed: false)
                                    .order(created_at: :desc) }
  scope :completed,           -> { where(completed: true)
                                    .order(completed_date: :desc) }
  
  validates :user_id,           presence: true
  validates :encrypted_goal,    presence: true, 
                                length: { maximum: 140 }
                      
  def has_improvement?(id)
    improvements.find_by(interaction_id: id)
  end
end