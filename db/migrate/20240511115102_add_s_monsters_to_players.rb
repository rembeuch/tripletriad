class AddSMonstersToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :s_monsters, :string, default: '[]'
  end
end
