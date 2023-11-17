class AddDecksToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :decks, :string, default: '[]'
  end
end
