class AddTurnToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :turn, :boolean
  end
end
