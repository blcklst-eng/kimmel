class AddViewedToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :viewed, :boolean, default: false, null: false
  end
end
