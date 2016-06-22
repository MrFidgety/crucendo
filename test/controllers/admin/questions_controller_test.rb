require 'test_helper'

class Admin::QuestionsControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:richard)
  end
  
  test "should get new" do
    session[:user_id] = @user.id
    get :new
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to root_url
  end
  
end
