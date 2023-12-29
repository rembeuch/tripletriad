class CreatePvps < ActiveRecord::Migration[7.1]
  def change
    create_table :pvps do |t|
      t.references :player1, null: false, foreign_key: { to_table: :players }
      t.references :player2, null: false, foreign_key: { to_table: :players }

      t.timestamps
    end
  end
end
