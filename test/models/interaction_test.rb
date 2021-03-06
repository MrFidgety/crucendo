require 'test_helper'

class InteractionTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:dinesh)
    @interaction = @user.interactions.build
  end
  
  test "should be valid" do
    assert @interaction.valid?
  end
  
  test "user id should be present" do
    @interaction.user_id = nil
    assert_not @interaction.valid?
  end
end
