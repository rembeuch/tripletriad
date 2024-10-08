class CreatePnjObjectives < ActiveRecord::Migration[7.1]
  def change
    create_table :pnj_objectives do |t|
      t.references :pnj, null: false, foreign_key: true
      t.string :name
      t.string :condition
      t.boolean :completed, default: false
      t.boolean :reveal, default: false

      t.timestamps
    end
  end
end
