require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  
  def setup
    @topic = Topic.new(name: "Topic", author_id: 1)
  end
  
  test "should be valid" do
    assert @topic.valid?
  end
  
  test "name should be present" do
    @topic.name = "     "
    assert_not @topic.valid?
  end
  
  test "name should be unique" do
    duplicate_topic = @topic.dup
    @topic.save
    assert_not duplicate_topic.valid?
  end
  
  test "name should not be too long" do
    @topic.name = "a" * 46
    assert_not @topic.valid?
  end
  
  test "name should be saved as lower-case" do
    mixed_case_name = "ExAMpLe"
    @topic.name = mixed_case_name
    @topic.save
    assert_equal mixed_case_name.downcase, @topic.reload.name
  end
end
