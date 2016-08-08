class Topic < ActiveRecord::Base
  has_many :questions
  before_save   :downcase_name
  validates :name,  presence: true, length: { maximum: 45 },
                    uniqueness: { case_sensitive: false }
                    
  default_scope -> { order(active: :desc, name: :asc) }
  
  private
    # Converts name to all lower-case.
    def downcase_name
      self.name = name.downcase
    end
    
end
