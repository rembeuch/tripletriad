class AddPlayerToElite < ActiveRecord::Migration[7.1]
  def change
    add_reference :elites, :player, null: false, foreign_key: true
  end
end
