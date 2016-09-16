require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:richard)
    @goal = @user.goals.build(encrypted_goal: "Be the best.")
  end
  
  test "should be valid" do
    assert @goal.valid?
  end

  test "user id should be present" do
    @goal.user_id = nil
    assert_not @goal.valid?
  end
  
  test "content should be present" do
    @goal.encrypted_goal = "   "
    assert_not @goal.valid?
  end

  test "content should be at most 140 characters" do
    @goal.encrypted_goal = "a" * 141
    assert_not @goal.valid?
  end
end
