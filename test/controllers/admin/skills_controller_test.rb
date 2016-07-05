require 'test_helper'

class Admin::SkillsControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:richard)
  end
  
  test "should get new" do
    session[:user_id] = @user.id
    get :new
    assert_response :success
  end

end
