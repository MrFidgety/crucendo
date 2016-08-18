class RemoveAuthorValuesFromTopics < ActiveRecord::Migration
  def self.up
    remove_column :topics, :author
    remove_column :topics, :picture
    remove_column :topics, :link
  end
  def self.down
    add_column :topics, :author, :text
    add_column :topics, :picture, :string
    add_column :topics, :link, :string
  end
end
