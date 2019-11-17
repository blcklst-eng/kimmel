class AddForwardingToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :forwarding, :boolean, default: false
  end
end
