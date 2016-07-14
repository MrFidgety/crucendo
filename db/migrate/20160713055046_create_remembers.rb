class CreateRemembers < ActiveRecord::Migration
  def change
    create_table :remembers do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :last_used_at
      t.string :remember_digest
      t.string :browser
      t.string :device
      t.string :platform

      t.timestamps null: false
    end
  end
end
