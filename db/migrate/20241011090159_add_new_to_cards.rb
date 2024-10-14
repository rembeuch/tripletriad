class AddNewToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :new, :boolean, :default => true
  end
end
