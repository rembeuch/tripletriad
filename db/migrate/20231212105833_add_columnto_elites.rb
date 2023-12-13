class AddColumntoElites < ActiveRecord::Migration[7.1]
  def change
    add_column :elites, :fight, :integer, default: 0
    add_column :elites, :diplomacy, :integer, default: 0
    add_column :elites, :espionage, :integer, default: 0
    add_column :elites, :leadership, :integer, default: 0
    add_column :elites, :potential, :boolean, default: false
  end
end
