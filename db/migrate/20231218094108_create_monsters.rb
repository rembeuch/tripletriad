class CreateMonsters < ActiveRecord::Migration[7.1]
  def change
    create_table :monsters do |t|

      t.timestamps
    end
  end
end
