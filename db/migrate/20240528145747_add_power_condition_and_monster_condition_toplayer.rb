class AddPowerConditionAndMonsterConditionToplayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :power_condition, :string
    add_column :players, :monster_condition, :string
  end
end
