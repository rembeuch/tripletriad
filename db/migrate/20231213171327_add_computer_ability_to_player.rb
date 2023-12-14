class AddComputerAbilityToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :computer_ability, :string
  end
end
