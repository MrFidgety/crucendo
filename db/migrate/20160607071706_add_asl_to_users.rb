class AddAslToUsers < ActiveRecord::Migration
  def change
    add_column :users, :year_of_birth, :integer, limit: 2
    add_column :users, :gender, :string
    add_column :users, :country_code, :string
  end
end
