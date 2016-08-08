class AddActiveToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :active, :boolean, default: false
  end
end
