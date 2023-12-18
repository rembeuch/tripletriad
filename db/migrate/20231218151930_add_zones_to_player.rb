class AddZonesToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :zones, :string, default: '[]'
  end
end
