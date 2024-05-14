class AddIndexToPlayersId < ActiveRecord::Migration[7.1]
  def change
    add_index :players, :id
  end
end
