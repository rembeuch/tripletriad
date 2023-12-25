class AddcolumnNftToElites < ActiveRecord::Migration[7.1]
  def change
    add_column :elites, :nft, :boolean, default: false
    add_column :elites, :in_sale, :boolean, default: false
    add_column :elites, :price, :integer, default: 0
  end
end
