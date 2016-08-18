class AddLinkToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :link, :string
  end
end
