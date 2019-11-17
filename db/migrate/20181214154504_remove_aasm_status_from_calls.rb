class RemoveAasmStatusFromCalls < ActiveRecord::Migration[5.2]
  def change
    remove_column :calls, :status, :string
  end
end
