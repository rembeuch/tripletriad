class AddLogsToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :logs, :string, default: '[]'
  end
end
