require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Welcome to The Crucial Team!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@thecrucialteam.com"], mail.from
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "account_login" do
    user = users(:michael)
    user.login_token = User.new_token
    mail = UserMailer.account_login(user)
    assert_equal "Welcome back to The Crucial Team!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@thecrucialteam.com"], mail.from
    assert_match user.login_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end
end
