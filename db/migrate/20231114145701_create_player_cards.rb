class CreatePlayerCards < ActiveRecord::Migration[7.1]
  def change
    create_table :player_cards do |t|
      t.string :up
      t.string :down
      t.string :right
      t.string :left
      t.string :position
      t.boolean :computer
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
