class Topic < ActiveRecord::Base
  has_many  :questions
  has_many  :subscriptions, dependent:  :destroy
  has_many  :subscribers,   through:    :subscriptions, source: :user

  before_save   :downcase_name
  validates :name,  presence: true, length: { maximum: 45 },
                    uniqueness: { case_sensitive: false }
  validate  :picture_size
  validates :link, :url => {:allow_blank => true}
                    
  scope :admin,   -> { order(active: :desc, name: :asc) }
  scope :active,  -> { where active: true }
  
  mount_uploader :picture, PictureUploader
  
  # finds next answer from this topic for a user
  def find_next_question(user)
    questions.active
      .joins("LEFT JOIN answers ON answers.question_id = questions.id 
              AND answers.user_id = "+ User.sanitize(user.id))
      .group("questions.id")
      .order("COUNT(answers.id) ASC, RANDOM()")
      .first
  end
  
  private
    # Converts name to all lower-case.
    def downcase_name
      self.name = name.downcase
    end
    
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
    
end
