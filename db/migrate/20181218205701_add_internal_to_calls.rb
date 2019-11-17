class AddInternalToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :internal, :boolean, default: false, null: false
  end
end
