class Question < ActiveRecord::Base
  include Filterable
  
  scope :topic_id, -> (topic_id) { where topic_id: topic_id }
  
  belongs_to :category
  belongs_to :topic
  validates :category_id, presence: true
  validates :topic_id, presence: true
  validates :content, presence: true, length: { maximum: 180 }
  
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
