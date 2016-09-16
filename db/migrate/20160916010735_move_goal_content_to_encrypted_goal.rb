class MoveGoalContentToEncryptedGoal < ActiveRecord::Migration
  def change
    Goal.all.each do |g|
      g.update_attributes!(encrypted_goal: g.content)
    end
  end
end
