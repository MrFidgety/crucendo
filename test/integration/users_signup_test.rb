require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get begin_path
    assert_no_difference 'User.count' do
      post users_path, user: { email: "user@invalid" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information" do
    get begin_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { email: "user@example.com" }
    end
    assert_template 'users/show'
    assert_not_empty flash
  end
end
