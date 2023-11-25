class AddInDeckToElites < ActiveRecord::Migration[7.1]
  def change
    add_column :elites, :in_deck, :boolean, default: false
  end
end
