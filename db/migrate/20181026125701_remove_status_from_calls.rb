class RemoveStatusFromCalls < ActiveRecord::Migration[5.2]
  def change
    remove_column :calls, :status, :integer, default: 0, null: false
  end
end
