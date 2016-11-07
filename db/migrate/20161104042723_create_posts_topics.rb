class CreatePostsTopics < ActiveRecord::Migration
  def change
    create_table :posts_topics do |t|
      t.references :topic, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
    end
  end
end
