class AddAuthorAndDefaultToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :author, :text
    add_column :topics, :default_subscription, :boolean, default: false
  end
end
