require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "The Crucial Team"
    assert_equal full_title("Help"), "Help | The Crucial Team"
    assert_equal full_title("Begin"), "Begin | The Crucial Team"
  end
end