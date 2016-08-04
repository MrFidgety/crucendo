class Goal < ActiveRecord::Base
  
  belongs_to  :user
  has_many    :steps
  has_many    :improvements
  has_one     :skill
  has_one     :interaction
  
  default_scope -> { order(due_date: :asc) }
  
  validates :user_id, presence: true
  validates :content, presence: true, 
                      length: { maximum: 140 }
                      
  def has_improvement?(interaction)
    improvements.find_by(interaction_id: interaction.id)
  end
end