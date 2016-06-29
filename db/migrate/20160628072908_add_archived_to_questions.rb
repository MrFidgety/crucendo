class AddArchivedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :archived, :boolean, default: false
  end
end
