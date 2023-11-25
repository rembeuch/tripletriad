class AddNameToElites < ActiveRecord::Migration[7.1]
  def change
    add_column :elites, :name, :string
  end
end
