class AddPowerPointsAndBooleanToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :power, :boolean, :default => false
    add_column :players, :power_point, :integer, :default => 0
  end
end
