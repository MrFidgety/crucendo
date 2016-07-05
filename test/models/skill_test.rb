require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  
  def setup
    @skill = Skill.new( name: "new skill", 
                        global: true)
  end
  
  test "should be valid" do
    assert @skill.valid?
  end
  
  test "name should be present" do
    @skill.name = "    "
    assert_not @skill.valid?
  end
  
  test "name should not be too long" do
    @skill.name = "a" * 46
    assert_not @skill.valid?
  end
  
  test "global should be present" do
    @skill.global = nil
    assert_not @skill.valid?
  end
  
end
