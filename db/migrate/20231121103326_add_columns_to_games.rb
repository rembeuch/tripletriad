class AddColumnsToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :rounds, :integer, default: 1
    add_column :games, :player_points, :integer,  default: 0
    add_column :games, :computer_points, :integer,  default: 0
  end
end
