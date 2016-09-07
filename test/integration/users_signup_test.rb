require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get root_url
    assert_no_difference 'User.count' do
      post root_url, user: { email: "user@invalid" }, xhr: true
    end
    assert_template 'users/new'
    assert_select 'div.error'
  end
  
  test "valid signup information with account activation" do
    get root_url
    assert_difference 'User.count', 1 do
      post root_url, user: { email: "user@example.com" }, xhr: true
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Expired activation token
    user.update_attribute(:activation_sent_at, 16.minutes.ago)
    get edit_account_activation_path(user.activation_token, 
                            email: user.email)
    assert_not is_logged_in?
    user.update_attribute(:activation_sent_at, Time.zone.now)
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert is_logged_in?
  end
end
