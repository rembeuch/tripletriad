class AddFinish1And2ToPvp < ActiveRecord::Migration[7.1]
  def change
    add_column :pvps, :finish1, :boolean, :default => false
    add_column :pvps, :finish2, :boolean, :default => false
  end
end
