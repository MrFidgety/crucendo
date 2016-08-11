class AddFeelingAndJournalToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :feeling, :integer
    add_column :interactions, :journal, :text
  end
end
