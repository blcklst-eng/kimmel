class AddAvailableToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :available, :boolean, default: true
  end
end
