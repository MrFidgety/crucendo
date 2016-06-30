class FixQuestionCategoryIdName < ActiveRecord::Migration
  def self.up
    rename_column :questions, :question_category_id, :category_id
  end

  def self.down
    rename_column :questions, :category_id, :question_category_id
  end
end
