class Topic < ActiveRecord::Base
  has_many  :questions
  has_many  :subscriptions, dependent:  :destroy
  has_many  :subscribers,   through:    :subscriptions, source: :user
  belongs_to :author
  has_and_belongs_to_many   :posts

  before_save   :downcase_name
  validates     :author_id,   presence: true
  validates     :name,        presence: true, length: { maximum: 45 },
                              uniqueness: { case_sensitive: false }

  scope :admin,   -> { order(active: :desc, name: :asc) }
  scope :active,  -> (value) { where(active: value) }
  
  # finds next answer from this topic for a user
  def find_next_question(user)
    questions.active(:true)
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
end
