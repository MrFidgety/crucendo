require 'test_helper'

class UsersChangeEmailTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:bighead)
  end
  
  test "invalid new email" do
    log_in_as @user
    ActionMailer::Base.deliveries.clear
    post "/changemyemail", email: "email@invalid"
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_nil @user.new_email
  end
  
  test "valid new email" do
    log_in_as @user
    ActionMailer::Base.deliveries.clear
    new_email = "email@valid.com"
    post "/changemyemail", email: new_email
    user = assigns(:user)
    assert_equal new_email, user.new_email
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Invalid new_email token
    get edit_change_user_email_path("invalid token", email: user.email)
    assert_not user.reload.new_email_approved?
    # Valid new_email, wrong email
    get edit_change_user_email_path(user.new_email_token, email: 'wrong')
    assert_not user.reload.new_email_approved?
    # Valid  new_email token
    get edit_change_user_email_path(user.new_email_token, email: user.email)
    user = assigns(:user)
    assert user.new_email_approved?
    # Valid new_email token from second email
    get edit_change_user_email_path(user.new_email_token, email: user.email)
    assert_equal new_email, user.reload.email
  end
end
