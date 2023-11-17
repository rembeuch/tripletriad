class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.string :up
      t.string :down
      t.string :left
      t.string :right
      t.string :rank

      t.timestamps
    end
  end
end
