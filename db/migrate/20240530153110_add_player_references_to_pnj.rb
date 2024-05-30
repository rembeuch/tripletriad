class AddPlayerReferencesToPnj < ActiveRecord::Migration[7.1]
  def change
    add_reference :pnjs, :player, null: false, foreign_key: true
  end
end
