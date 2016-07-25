class AddCompletedToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :completed, :boolean, default: false
  end
end
