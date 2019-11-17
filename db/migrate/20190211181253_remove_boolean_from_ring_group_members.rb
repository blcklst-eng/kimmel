class RemoveBooleanFromRingGroupMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :ring_group_members, :boolean, :boolean, default: false, null: false
  end
end
