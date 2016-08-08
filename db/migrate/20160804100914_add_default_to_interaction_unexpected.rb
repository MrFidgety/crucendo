class AddDefaultToInteractionUnexpected < ActiveRecord::Migration
  def change
    change_column :improvements, :unexpected, :boolean, :default => false
  end
end
