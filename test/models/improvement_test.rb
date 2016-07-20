require 'test_helper'

class ImprovementTest < ActiveSupport::TestCase
  
  def setup
    @goal = goals(:g1)
    @improvement = @goal.improvements.build
  end
  
  test "should be valid" do
    assert @improvement.valid?
  end
  
  test "goal id should be present" do
    @improvement.goal_id = nil
    assert_not @improvement.valid?
  end
  
  test "value should be 1" do
    @improvement.value = 0
    assert_not @improvement.valid?
  end
  
  test "order should be most recent first" do
    assert_equal improvements(:most_recent), Improvement.first
  end
end
