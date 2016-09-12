require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @activated_user = users(:richard)
    @unactivated_user = users(:gilfoyle)
    ActionMailer::Base.deliveries.clear
  end
  
  test "login with unactivated account" do
    assert_not @unactivated_user.activated?
    # set activation link to expired
    @unactivated_user.update_attribute(:activation_sent_at, 25.hours.ago)
    post root_url, user: { email: @unactivated_user.email }, xhr: true
    # ensure new activation is automatically sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    # set activation link to valid
    ActionMailer::Base.deliveries.clear
    @unactivated_user.update_attribute(:activation_sent_at, Time.zone.now)
    post root_url, user: { email: @unactivated_user.email }, xhr: true
    # ensure new activation is not automatically sent
    assert_equal 0, ActionMailer::Base.deliveries.size
    post sendemail_path, session: { email: @unactivated_user.email}, xhr: true
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
  
  test "email login with active account" do
    assert @activated_user.activated?
    # Simulate click of 'havent set password' button
    post sendemail_path, session: { email: @activated_user.email }, xhr: true
    # Get instance variable so login token can be accessed
    user = assigns(:user)
    # Ensure login email is sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Invalid activation token
    get edit_session_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_session_path(user.login_token, email: 'wrong')
    assert_not is_logged_in?
    # Expired login token
    @activated_user.update_attribute(:login_sent_at, 25.hours.ago)
    get edit_session_path(user.login_token, 
                            email: @activated_user.email)
    assert_not is_logged_in?
    @activated_user.update_attribute(:login_sent_at, Time.zone.now)
    # Valid login token
    assert_difference 'Remember.count', 1 do
      get edit_session_path(user.login_token, 
                            email: @activated_user.email)
    end
    assert @activated_user.reload.activated?
  end
  
  test "login with remembering" do
    log_in_as(@activated_user)
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  test 'logout' do
    log_in_as(@activated_user)
    assert_difference 'Remember.count', -1 do
      delete logout_path
    end
  end
end
