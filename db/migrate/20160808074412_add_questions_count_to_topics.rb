class AddQuestionsCountToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :questions_count, :integer, default: 0
    
    Topic.all.each do |topic|
      Topic.reset_counters(topic.id, :questions)
    end
  end
end