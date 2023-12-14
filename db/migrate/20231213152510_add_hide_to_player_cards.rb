class AddHideToPlayerCards < ActiveRecord::Migration[7.1]
  def change
    add_column :player_cards, :hide, :boolean, default: true
  end
end
