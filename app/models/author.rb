class Author < ActiveRecord::Base
  has_many  :topics
  has_many  :posts
  
  validate  :logo_size
  validates :link, :url => true
  validates :name,  presence: true, uniqueness: { case_sensitive: false }
                    
  mount_uploader :logo, PictureUploader
  
  # returns authors that have at least one blog post
  #scope :has_posts, -> { joins(:posts).uniq }
  scope :has_posts, -> { select("authors.*, MAX(posts.published_date) AS recent_post").joins(:posts).group("authors.id").order("recent_post DESC") }
  
  private
    # Validates the size of an uploaded picture.
    def logo_size
      if logo.size > 5.megabytes
        errors.add(:logo, "should be less than 5MB")
      end
    end
end
