class AddCreatedAtIndexToCallsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :calls, :created_at
  end
end
