class AddAbilityToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :ability, :string
  end
end
