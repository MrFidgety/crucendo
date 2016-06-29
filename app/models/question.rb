class Question < ActiveRecord::Base
  belongs_to :question_category
  validates :question_category_id, presence: true
  validates :content, presence: true, length: { maximum: 180 }
  
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
