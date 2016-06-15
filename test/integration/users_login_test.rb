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
    @unactivated_user.update_attribute(:activation_sent_at, 16.minutes.ago)
    post_to_begin @unactivated_user
    # ensure new activation is automatically sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    # set activation link to valid
    ActionMailer::Base.deliveries.clear
    @unactivated_user.update_attribute(:activation_sent_at, Time.zone.now)
    post_to_begin @unactivated_user
    # ensure new activation is not automatically sent
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    assert_select "a[href=?]", resend_path(email: @unactivated_user.email)
    get resend_path(email: @unactivated_user.email)
    assert_equal 1, ActionMailer::Base.deliveries.size
    follow_redirect!
    assert_not flash.empty?
  end
  
  test "login with active account" do
    assert @activated_user.activated?
    post_to_begin @activated_user
    # get instance variable so login token can be accessed
    user = assigns(:user)
    # ensure login email is sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    # Invalid activation token
    get edit_session_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_session_path(user.login_token, email: 'wrong')
    assert_not is_logged_in?
    # Expired login token
    @activated_user.update_attribute(:login_sent_at, 16.minutes.ago)
    get edit_session_path(user.login_token, 
                            email: @activated_user.email)
    assert_not is_logged_in?
    @activated_user.update_attribute(:login_sent_at, Time.zone.now)
    # Valid activation token
    get edit_session_path(user.login_token, 
                            email: @activated_user.email)
    assert @activated_user.reload.activated?
  end
  
  test "login with remembering" do
    log_in_as(@activated_user)
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
end
