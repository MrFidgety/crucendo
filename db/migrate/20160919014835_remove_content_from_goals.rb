class RemoveContentFromGoals < ActiveRecord::Migration
  def change
    remove_column :goals, :content, :text
  end
end
