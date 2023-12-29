class AddPvpPowerToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :pvp_power, :boolean, :default => false
    add_column :players, :pvp_power_point, :integer, :default => 0
  end
end
