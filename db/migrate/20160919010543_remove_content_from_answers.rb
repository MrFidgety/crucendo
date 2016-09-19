class RemoveContentFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :content, :text
  end
end
