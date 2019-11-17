class AddCallerIdAsParentNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :caller_id_as_parent, :boolean, default: false
  end
end
