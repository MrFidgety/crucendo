class AddLoginDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_digest, :string
  end
end
