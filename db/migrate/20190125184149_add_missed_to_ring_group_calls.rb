class AddMissedToRingGroupCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :ring_group_calls, :missed, :boolean, default: false, null: false
  end
end
