class AddCategoryIdToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :question_category, index: true, foreign_key: true
  end
end
