require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'users/new'
    get help_path
    assert_select "title", full_title("Help")
  end
end
