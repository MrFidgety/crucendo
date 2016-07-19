class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.datetime :due_date
      t.boolean :completed, default: true
      t.datetime :completed_date

      t.timestamps null: false
    end
    
    add_index :goals, [:user_id, :due_date]
  end
end
