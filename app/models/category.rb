class Category < ActiveRecord::Base
  has_many :questions
  before_save   :downcase_name
  validates :name,  presence: true, length: { maximum: 45 },
                    uniqueness: { case_sensitive: false }
                    
  private
    # Converts name to all lower-case.
    def downcase_name
      self.name = name.downcase
    end
end