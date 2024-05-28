class AddMaxToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :max, :boolean, :default => false
  end
end
