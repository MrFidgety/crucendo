class Goal < ActiveRecord::Base
  
  belongs_to  :user
  has_many    :steps
  has_many    :improvements, dependent: :destroy
  has_one     :skill
  has_one     :interaction
  
  scope :due_soonest,         -> { order(due_date: :asc, content: :asc) }
  scope :active,              -> { where(completed: false, active: true) }
  scope :active_most_recent,  -> { active.order(created_at: :desc) }
  scope :inactive,            -> { where(active: false).order(created_at: :desc) }
  scope :alphabetical,        -> { order(content: :asc) }
  scope :completed,           -> { where(completed: true).order(completed_date: :desc) }
  
  validates :user_id, presence: true
  validates :content, presence: true, 
                      length: { maximum: 140 }
                      
  def has_improvement?(interaction)
    improvements.find_by(interaction_id: interaction.id)
  end
end