class Category < ActiveRecord::Base
  has_many :questions
  validates :name, presence: true, length: { maximum: 45 }
end
