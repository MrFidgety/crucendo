class RemoveLastUsedAtFromRemember < ActiveRecord::Migration
  def change
    remove_column :remembers, :last_used_at, :datetime
  end
end
