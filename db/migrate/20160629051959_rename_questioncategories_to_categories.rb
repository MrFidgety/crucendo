class RenameQuestioncategoriesToCategories < ActiveRecord::Migration
  def self.up
    rename_table :question_categories, :categories
  end

  def self.down
    rename_table :categories, :question_categories
  end
end
