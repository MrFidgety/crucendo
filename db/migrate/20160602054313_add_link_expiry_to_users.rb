class AddLinkExpiryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_sent_at, :datetime
  end
end
