class AddInteractionIdToGoals < ActiveRecord::Migration
  def change
    add_reference :goals, :interaction, index: true, foreign_key: true
  end
end
