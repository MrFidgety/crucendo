class CreateImprovements < ActiveRecord::Migration
  def change
    create_table :improvements do |t|
      t.references :goal, index: true, foreign_key: true
      t.references :step, index: true, foreign_key: true
      t.integer :value
      t.boolean :unexpected

      t.timestamps null: false
    end
  end
end
