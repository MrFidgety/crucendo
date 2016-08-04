class AddInteractionIdToImprovements < ActiveRecord::Migration
  def change
    add_reference :improvements, :interaction, index: true, foreign_key: true
  end
end
