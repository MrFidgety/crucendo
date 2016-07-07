class Skill < ActiveRecord::Base
  include Filterable
  
  scope :global, -> (global) { where global: global }
  
  before_save { self.name = name.downcase }
  validates :name,  presence: true, length: { maximum: 45 },
                    uniqueness: { case_sensitive: false }
  validates_inclusion_of :global, in: [true, false]
  
  def self.search(search)
    if !search.blank?
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
