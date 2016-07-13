class Goal < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(due_date: :asc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
