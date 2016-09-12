class User < ActiveRecord::Base
  
  attr_accessor :remember_token, 
                :activation_token, 
                :login_token, 
                :new_email_token
  
  has_many      :goals,         dependent:  :destroy
  has_many      :interactions,  dependent:  :destroy
  has_many      :remembers,     dependent:  :destroy
  has_many      :answers,       dependent:  :destroy
  has_many      :improvements,  through:    :goals,       dependent:  :destroy
  has_many      :subscriptions, dependent:  :destroy
  has_many      :topics,        through:    :subscriptions
  
  before_save   :downcase_email
  after_create  :default_subscriptions
  
  scope :created_recent,       -> { order(created_at: :desc) }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  has_secure_password validations: false
  
  validates :name,          length: { maximum: 50 }
  validates :email,         presence: { message: "the first step to 
                            impressing yourself is providing your email 
                            address" }, 
                            length: { maximum: 255 },
                            format: { with: VALID_EMAIL_REGEX, 
                            message: "our robot, Baxter, has told us that 
                            this email address isn't valid" },
                            uniqueness: { case_sensitive: false }
  validates :year_of_birth, numericality: { only_integer: true, 
                            greater_than_or_equal_to: Time.zone.now.year - 100, 
                            less_than_or_equal_to: Time.zone.now.year}, 
                            allow_nil: true
  validates :gender,        inclusion: { in: %w(female male) }, 
                            allow_nil: true
  validates :password,      length: { in: (8..32), 
                            too_long: "thats too long mate, 32 characters or less please", 
                            too_short: "thats too short mate, 8 characters or more please"}, 
                            confirmation: true, 
                            if: :setting_password?
  
  class << self              
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
    
    def to_csv
      attributes = %w{id email name gender activated country_code time_zone password_digest}
  
      CSV.generate(headers: true) do |csv|
        csv << attributes
  
        all.each do |user|
          csv << attributes.map{ |attr| user.send(attr) }
        end
      end
    end
  end
  
  def interaction_streak_days
    Interaction.interaction_streak_days(self)
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    self.remembers.create(remember_digest: User.digest(remember_token))
  end
  
  # Return true if user has password
  def has_password?
    !self.password_digest.blank?
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Returns true if token matches on of the users remembers.
  def remembered?(token)
    found = false
    remembers.each do |remember|
      if BCrypt::Password.new(remember.remember_digest).is_password?(token)
        remember.touch
        found = true;
      end
    end
    return found;
  end
  
  # Forgets a user by removing the matching remember token.
  def forget(token)
    remembers.each do |remember|
      if BCrypt::Password.new(remember.remember_digest).is_password?(token)
        remember.delete
      end
    end
  end
  
   # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Creates activation token and sends activation email.
  def send_activation_email
    create_activation_digest
    UserMailer.account_activation(self).deliver_now
  end
  
  # Returns true if a activation link has expired.
  def activation_link_expired?
    activation_sent_at < 15.minutes.ago
  end
  
  # Creates login token and sends login email.
  def send_login_email
    create_login_digest
    UserMailer.account_login(self).deliver_now
  end
  
  # Returns true if a login link has expired.
  def login_link_expired?
    login_sent_at < 15.minutes.ago
  end
  
  # Send email requesting approval for change of email.
  def send_change_email_approval(email)
    self.new_email_token  = User.new_token
    update_columns( new_email: email,
                    new_email_digest:  User.digest(new_email_token),
                    new_email_sent_at: Time.zone.now)
    UserMailer.change_email_approval(self).deliver_now
  end
  
  # Send email activating new email address.
  def send_change_email_activation
    self.new_email_token  = User.new_token
    update_columns( new_email_approved: true,
                    new_email_digest:  User.digest(new_email_token))
    UserMailer.change_email_activation(self).deliver_now
  end
  
  def change_email
    update_attribute(:email, self.new_email)
    clear_new_email
  end
  
  # Clear all user attributes related to changing email address.
  def clear_new_email
    update_columns( new_email_approved: false,
                    new_email: nil,
                    new_email_digest: nil,
                    new_email_sent_at: nil )
  end
  
  # Returns true if a change of email has expired.
  def change_email_expired?
    new_email_sent_at < 15.minutes.ago
  end
  
  # Subscribe to a topic
  def subscribe(topic)
    subscriptions.create(topic_id: topic.id)
  end
  
  # Unsubscribe from a topic
  def unsubscribe(topic)
    subscriptions.find_by(topic_id: topic.id).destroy
  end
  
  # Returns true if user is sunscribed to a topic
  def subscribed?(topic)
    topics.include?(topic)
  end
  
  def default_subscriptions
    Topic.active.where(default_subscription: true).each do |topic|
      subscribe(topic)
    end
  end
  
  private
  
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
  
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      update_columns( activation_digest:  User.digest(activation_token),
                      activation_sent_at: Time.zone.now)
    end
    
    # Creates and assigns the login token and digest.
    def create_login_digest
      self.login_token  = User.new_token
      update_columns( login_digest:  User.digest(login_token),
                      login_sent_at: Time.zone.now)
    end
    
    # checks if either password field has a value
    def setting_password?
      password || password_confirmation
    end
end