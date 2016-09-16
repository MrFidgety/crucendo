class AddEncryptedGoalToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :encrypted_goal, :text
  end
end
