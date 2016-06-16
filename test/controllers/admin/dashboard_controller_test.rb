require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:dinesh)
  end
  
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to root_url
  end
  
end
