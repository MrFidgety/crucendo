class AddDefaultValueToGoalsCompleted < ActiveRecord::Migration
  def change
    change_column_default :goals, :completed, false
  end
end
