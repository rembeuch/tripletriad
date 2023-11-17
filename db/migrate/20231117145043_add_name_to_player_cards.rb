class AddNameToPlayerCards < ActiveRecord::Migration[7.1]
  def change
    add_column :player_cards, :name, :string
  end
end
