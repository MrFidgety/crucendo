require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  #test "login with remembering" do
  #  log_in_as(@user)
  #  assert_equal cookies['remember_token'], assigns(:user).remember_token
  #end
end
