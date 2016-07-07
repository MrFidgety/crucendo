class AddNewEmailApprovalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_email_approved, :boolean, default: false
  end
end
