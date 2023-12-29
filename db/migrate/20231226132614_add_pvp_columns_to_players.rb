class AddPvpColumnsToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :in_pvp, :string, :default => "false"
  end
end
