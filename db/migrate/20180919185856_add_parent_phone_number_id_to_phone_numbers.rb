class AddParentPhoneNumberIdToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_reference :phone_numbers, :phone_number, foreign_key: :parent_phone_number_id
  end
end
