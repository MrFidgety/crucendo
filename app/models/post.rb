class Post < ActiveRecord::Base
  belongs_to :author
  
  validate  :image_size
  validates :title,     presence: true
  validates :summary,   presence: true
  validates :content,   presence: true
                    
  mount_uploader :image, PictureUploader
  
  private
    # Validates the size of an uploaded picture.
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "should be less than 5MB")
      end
    end
end
