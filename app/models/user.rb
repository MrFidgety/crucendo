class User < ActiveRecord::Base
  
  attr_accessor :remember_token, 
                :activation_token, 
                :login_token, 
                :new_email_token
  
  has_many :goals,        dependent:  :destroy
  has_many :interactions, dependent:  :destroy
  has_many :remembers,    dependent:  :destroy
  has_many :answers,      through:    :interactions
  has_many :improvements, through:    :goals
  
  before_save   :downcase_email
  before_create :create_activation_digest
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :name,          length: { maximum: 50 }
  validates :email,         presence: true, 
                            length: { maximum: 255 },
                            format: { with: VALID_EMAIL_REGEX },
                            uniqueness: { case_sensitive: false }
  validates :year_of_birth, length: { is: 4 }, 
                            allow_nil: true
  validates :gender,        inclusion: { in: %w(female male) }, 
                            allow_nil: true
  
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
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    self.remembers.create(remember_digest: User.digest(remember_token))
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

  # Sends activation email.
  def send_activation_email
    update_attribute(:activation_sent_at, Time.zone.now)
    UserMailer.account_activation(self).deliver_now
  end
  
  # Resends activation email.
  def resend_activation_email
    self.activation_token  = User.new_token
    update_columns(activation_digest:  User.digest(activation_token),
                   activation_sent_at: Time.zone.now)
    UserMailer.account_activation(self).deliver_now
  end
  
  # Returns true if a activation link has expired.
  def activation_link_expired?
    activation_sent_at < 15.minutes.ago
  end
  
  # Sends login email.
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
  
  private
  
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
  
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
    # Creates and assigns the login token and digest.
    def create_login_digest
      self.login_token  = User.new_token
      update_columns(login_digest:  User.digest(login_token),
               login_sent_at: Time.zone.now)
    end
end