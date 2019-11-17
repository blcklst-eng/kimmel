class AddAasmStatusToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :status, :string
  end
end
