require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  
  def setup
    @question = questions(:q1)
    @interaction = interactions(:i1)
    @answer = Answer.new(interaction_id: @interaction.id, question_id: @question.id)
  end
  
  test "should be valid" do 
    assert @answer.valid?
  end
  
  test "interaction id should be present" do
    @answer.interaction_id = nil
    assert_not @answer.valid?
  end
  
  test "question id should be present" do
    @answer.question_id = nil
    assert_not @answer.valid?
  end
  
  test "content should not be too long" do
    @answer.encrypted_answer = "a" * 3501
    assert_not @answer.valid?
  end
  
end
