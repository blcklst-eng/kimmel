class RemoveActiveFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :active, :boolean, default: true
  end
end
