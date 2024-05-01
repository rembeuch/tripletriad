class AddBossToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :boss, :boolean, :default => false
  end
end
