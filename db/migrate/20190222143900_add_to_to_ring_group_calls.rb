class AddToToRingGroupCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :ring_group_calls, :to, :string, array: true, default: [], null: false
  end
end
