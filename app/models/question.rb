class Question < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 180 }
end
