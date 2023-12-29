class AddPvpBooleanToPlayerCards < ActiveRecord::Migration[7.1]
  def change
    add_column :player_cards, :pvp, :boolean, default: false
  end
end
