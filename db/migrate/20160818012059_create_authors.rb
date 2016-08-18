class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :logo
      t.string :link
      t.text :about

      t.timestamps null: false
    end
  end
end
