class AddCallerIdNumberStringToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :caller_id_number, :string
  end
end
