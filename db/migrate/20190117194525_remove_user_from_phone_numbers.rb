class RemoveUserFromPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :phone_numbers, :user, foreign_key: true
  end
end
