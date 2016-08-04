class AddImprovementsCountToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :improvements_count, :integer, default: 0
    
    Goal.all.each do |goal|
      Goal.reset_counters(goal.id, :improvements)
    end
  end
end
