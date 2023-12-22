class AddElitePointsToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :elite_points, :integer, default: 0
  end
end
