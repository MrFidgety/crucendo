class Question < ActiveRecord::Base
  include Filterable
  
  belongs_to :topic, :counter_cache => true
  has_many :answers, dependent:  :destroy
  
  validates :topic_id, presence: true
  validates :content, presence: true, length: { maximum: 180 }
  
  default_scope     -> { where(archived: false) }
  scope :admin,     -> { order(active: :desc, content: :asc) }
  scope :topic_id,  -> (topic_id) { where topic_id: topic_id }
  scope :active,    -> (value) { where(active: value) }
  
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
