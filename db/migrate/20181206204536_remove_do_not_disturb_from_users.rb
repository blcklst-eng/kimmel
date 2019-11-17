class RemoveDoNotDisturbFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :do_not_disturb, :boolean, default: false
  end
end
