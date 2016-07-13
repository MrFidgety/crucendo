require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:richard)
    @goal = @user.goals.build(content: "Be the best.")
  end
  
  test "should be valid" do
    assert @goal.valid?
  end

  test "user id should be present" do
    @goal.user_id = nil
    assert_not @goal.valid?
  end
  
  test "content should be present" do
    @goal.content = "   "
    assert_not @goal.valid?
  end

  test "content should be at most 140 characters" do
    @goal.content = "a" * 141
    assert_not @goal.valid?
  end
  
  test "order should be soonest due first" do
    assert_equal goals(:due_soonest), Goal.first
  end
end
