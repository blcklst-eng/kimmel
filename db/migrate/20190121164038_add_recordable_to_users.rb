class AddRecordableToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :recordable, :boolean, default: true, null: false
  end
end
