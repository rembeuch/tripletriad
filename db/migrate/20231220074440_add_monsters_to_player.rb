class AddMonstersToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :monsters, :string, default: '[]'
    add_column :players, :energy, :integer, default: 0

    add_column :cards, :copy, :integer, default: 0
  end
end
