class AddDoNotDisturbToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :do_not_disturb, :boolean, default: false
  end
end
