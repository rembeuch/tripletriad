class AddColumnToMonsters < ActiveRecord::Migration[7.1]
  def change
    add_column :monsters, :zones, :string, default: '[]'
    add_column :monsters, :up, :integer
    add_column :monsters, :down, :integer
    add_column :monsters, :right, :integer
    add_column :monsters, :left, :integer
    add_column :monsters, :rank, :integer
    add_column :monsters, :rules, :string, default: '[]'
    add_column :monsters, :name, :string
    add_column :monsters, :image, :string


    add_reference :cards, :player, null: false, foreign_key: true
    add_column :cards, :up_points, :integer
    add_column :cards, :down_points, :integer
    add_column :cards, :right_points, :integer
    add_column :cards, :left_points, :integer
    add_column :cards, :name, :string
    add_column :cards, :image, :string

  end
end
