class AddMonstersToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :monsters, :string, default: '[]'
  end
end
