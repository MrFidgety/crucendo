class Question < ActiveRecord::Base
  belongs_to :category
  validates :category_id, presence: true
  validates :content, presence: true, length: { maximum: 180 }
  
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
