class AddScreenerNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :screener_number, foreign_key: {to_table: :phone_numbers}
  end
end
