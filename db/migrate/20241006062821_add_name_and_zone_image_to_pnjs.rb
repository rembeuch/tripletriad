class AddImageAndZoneImageToPnjs < ActiveRecord::Migration[7.1]
  def change
    add_column :pnjs, :name, :string
    add_column :pnjs, :zone_image, :string
  end
end
