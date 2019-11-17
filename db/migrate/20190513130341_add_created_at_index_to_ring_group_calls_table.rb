class AddCreatedAtIndexToRingGroupCallsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :ring_group_calls, :created_at
  end
end
