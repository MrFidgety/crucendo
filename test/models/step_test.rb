require 'test_helper'

class StepTest < ActiveSupport::TestCase
  
  def setup
    @goal = goals(:g1)
    @step = @goal.steps.build(content: "Take your time.")
  end
  
  test "should be valid" do
    assert @step.valid?
  end
  
  test "goal id should be present" do
    @step.goal_id = nil
    assert_not @step.valid?
  end
  
  test "content should be present" do
    @step.content = "   "
    assert_not @step.valid?
  end

  test "content should be at most 140 characters" do
    @step.content = "a" * 141
    assert_not @step.valid?
  end
  
  test "steps should be in order" do
    assert_equal steps(:first), Step.first
    assert_equal steps(:last), Step.last
  end
end
