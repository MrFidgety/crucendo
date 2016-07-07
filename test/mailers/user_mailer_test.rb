require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:gilfoyle)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Welcome to The Crucial Team!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@thecrucialteam.com"], mail.from
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "account_login" do
    user = users(:richard)
    user.login_token = User.new_token
    mail = UserMailer.account_login(user)
    assert_equal "Welcome back to The Crucial Team!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@thecrucialteam.com"], mail.from
    assert_match user.login_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end
  
  test "change_email_approval" do
    user = users(:bighead)
    user.new_email_token = User.new_token
    mail = UserMailer.change_email_approval(user)
    assert_equal "Your New Email Address", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@thecrucialteam.com"], mail.from
    assert_match user.new_email_token,   mail.body.encoded
    #assert_match CGI::escape(user.email), mail.body.encoded
  end
  
  test "change_email_activation" do
    user = users(:bighead)
    user.new_email_token = User.new_token
    user.new_email = "bighead@piedpiper.com"
    mail = UserMailer.change_email_activation(user)
    assert_equal "Your New Email Address", mail.subject
    assert_equal [user.new_email], mail.to
    assert_equal ["noreply@thecrucialteam.com"], mail.from
    assert_match user.new_email_token,   mail.body.encoded
    #assert_match CGI::escape(user.email), mail.body.encoded
  end
end
