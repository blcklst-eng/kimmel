class AddCallerIdNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :caller_id_number, foreign_key: {to_table: :phone_numbers}
  end
end
