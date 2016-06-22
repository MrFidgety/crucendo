require 'test_helper'

class Admin::Questions::CategoriesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
