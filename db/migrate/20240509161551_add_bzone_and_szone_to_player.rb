class AddBzoneAndSzoneToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :b_zone, :boolean, :default => false
    add_column :players, :s_zone, :boolean, :default => false
  end
end
