require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Crucendo"
    assert_equal full_title("Help"), "Help | Crucendo"
    assert_equal full_title("Begin"), "Begin | Crucendo"
  end
end