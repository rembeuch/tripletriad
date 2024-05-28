class AddBonusToplayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :bonus, :boolean, :default => false
  end
end
