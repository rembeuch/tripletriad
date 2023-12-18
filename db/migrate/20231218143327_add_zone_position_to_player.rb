class AddZonePositionToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :zone_position, :string, default: "A1"
  end
end
