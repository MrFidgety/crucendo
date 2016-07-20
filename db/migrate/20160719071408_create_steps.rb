class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.references :goal, index: true, foreign_key: true
      t.text :content
      t.boolean :completed, default: false
      t.datetime :completed_date
      t.integer :order

      t.timestamps null: false
    end
  end
end
