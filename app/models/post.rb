class Post < ActiveRecord::Base
  extend FriendlyId
  include Filterable
  
  attr_accessor             :image_width, :image_height
  belongs_to                :author
  has_and_belongs_to_many   :topics
  
  scope :active,      -> (value) { where(active: value) }
  scope :most_recent, -> { order(published_date: :desc) }
  scope :min_date,  -> (date) { where("published_date >= ?", date.beginning_of_day) }
  scope :max_date,  -> (date) { where("published_date <= ?", date.end_of_day) }
  scope :posts_with_track, -> (track_id) { joins(:topics).where(topics: { id: track_id}) }
  scope :posts_from_author, -> (author_id) { where(author_id: author_id) }
  
  friendly_id :url_builder, use: [:slugged, :finders, :history]
  
  validate  :image_size
  validates :title,     presence: true, length: { maximum: 100 }
  validates :content, :image, :author_id,   presence: true
  validates :summary,   presence: true, length: { maximum: 300 }
  validate  :check_image_dimensions
                    
  mount_uploader :image, BannerUploader
  
  # Create URL for this post
  def url_builder
    if author.present?
      url = "#{title} #{author.name}"
      topics.each do |t|
        url += " #{t.name}"
      end
      return url
    end
  end
  
  # Determine if new URL needs to be generated
  def should_generate_new_friendly_id?
    title_changed? || super
  end
  
  # Check dimensions provided from Banner Uploader
  def check_image_dimensions
    if !image_cache.nil? && (image.width < 960 || image.height < 405)
      errors.add :image, "Dimension too small, needs to be at least 960x405."
    end
  end

  private
    # Validates the size of an uploaded picture.
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "should be less than 5MB")
      end
    end
end
