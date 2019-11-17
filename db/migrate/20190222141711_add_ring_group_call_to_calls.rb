class AddRingGroupCallToCalls < ActiveRecord::Migration[5.2]
  def change
    add_reference :calls, :ring_group_call, foreign_key: true, null: true
  end
end
