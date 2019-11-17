class RemoveCallerIdAsParentFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :caller_id_as_parent, :boolean, default: false
  end
end
