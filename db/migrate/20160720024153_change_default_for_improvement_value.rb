class ChangeDefaultForImprovementValue < ActiveRecord::Migration
  def change
    change_column :improvements, :value, :integer, :default => 1
  end
end
