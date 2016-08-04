class RemoveCurrentStepFromInteractions < ActiveRecord::Migration
  def change
    remove_column :interactions, :current_step
  end
end
