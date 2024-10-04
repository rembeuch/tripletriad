class AddDialogueToPnjs < ActiveRecord::Migration[7.1]
  def change
    add_column :pnjs, :dialogue, :string, default: '[]'
  end
end
