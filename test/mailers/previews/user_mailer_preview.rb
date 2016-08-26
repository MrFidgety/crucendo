# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_login
  def account_login
    user = User.first
    user.login_token = User.new_token
    UserMailer.account_login(user)
  end
  
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/change_email_approval
  def change_email_approval
    user = User.first
    user.new_email = 'new@email.com'
    user.new_email_token = User.new_token
    UserMailer.change_email_approval(user)
  end
  
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/change_email_activation
  def change_email_activation
    user = User.first
    user.new_email = 'new@email.com'
    user.new_email_token = User.new_token
    UserMailer.change_email_activation(user)
  end

end
