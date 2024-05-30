class CreatePnjs < ActiveRecord::Migration[7.1]
  def change
    create_table :pnjs do |t|
      t.integer :try, default: 0
      t.integer :victory, default: 0
      t.integer :defeat, default: 0
      t.integer :perfect, default: 0
      t.integer :boss, default: 0
      t.integer :awake, default: 0
      t.string :zone

      t.timestamps
    end
  end
end
