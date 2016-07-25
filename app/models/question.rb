class Question < ActiveRecord::Base
  include Filterable
  
  scope :topic_id,  -> (topic_id) { where topic_id: topic_id }
  scope :active,    -> (active) { where active: active }
  
  belongs_to :topic
  has_many :answers
  
  validates :topic_id, presence: true
  validates :content, presence: true, length: { maximum: 180 }
  
  def self.search(search)
    if !search.blank?
      where('content LIKE ?', "%#{search}%")
    else
      all
    end
  end
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      if !row["topic"].blank? && !row["content"].blank?
        topic = Topic.find_or_create_by(name: row["topic"].downcase)
        Question.create!({ :content => row["content"], :topic_id => topic.id })
      end
    end
  end
end
