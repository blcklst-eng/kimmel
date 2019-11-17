class AddForwardingWithNumberToUsers < ActiveRecord::Migration[5.2]
  change_table :users, bulk: true do |t|
    t.boolean :call_forwarding, default: false
    t.string :call_forwarding_number, null: true
  end
end
