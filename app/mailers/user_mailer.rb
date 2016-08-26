class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Welcome to Crucendo!"
  end

  def account_login(user)
    @user = user
    mail to: user.email, subject: "Welcome back to Crucendo!"
  end
  
  def change_email_approval(user)
    @user = user
    mail to: user.email, subject: "Change email - Step 1"
  end
  
  def change_email_activation(user)
    @user = user
    mail to: user.new_email, subject: "Change email - Step 2"
  end
end
