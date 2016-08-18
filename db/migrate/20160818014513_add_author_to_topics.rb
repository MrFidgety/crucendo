class AddAuthorToTopics < ActiveRecord::Migration
  def change
    add_reference :topics, :author, index: true, foreign_key: true
  end
end
