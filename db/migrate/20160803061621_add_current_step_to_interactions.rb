class AddCurrentStepToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :current_step, :string, :default => "questions"
  end
end
