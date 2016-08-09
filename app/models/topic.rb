class Topic < ActiveRecord::Base
  has_many :questions
  accepts_nested_attributes_for :questions
  before_save   :downcase_name
  validates :name,  presence: true, length: { maximum: 45 },
                    uniqueness: { case_sensitive: false }
                    
  default_scope   -> { order(active: :desc, name: :asc) }
  scope :active,  -> { where active: true }
  
  private
    # Converts name to all lower-case.
    def downcase_name
      self.name = name.downcase
    end
    
end
