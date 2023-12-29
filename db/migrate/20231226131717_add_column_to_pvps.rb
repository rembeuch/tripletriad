class AddColumnToPvps < ActiveRecord::Migration[7.1]
  def change
    add_column :pvps, :rounds, :integer, default: 1
    add_column :pvps, :player1_points, :integer,  default: 0
    add_column :pvps, :player2_points, :integer,  default: 0
    add_column :pvps, :turn, :integer
    add_column :pvps, :logs, :string, default: '[]'
    add_column :pvps, :monsters, :string, default: '[]'

  end
end
