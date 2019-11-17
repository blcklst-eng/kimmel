class AddRecordToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :recorded, :boolean, default: false
  end
end
