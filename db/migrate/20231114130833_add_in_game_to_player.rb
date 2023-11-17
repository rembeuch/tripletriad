class AddInGameToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :in_game, :boolean, :default => false
  end
end
