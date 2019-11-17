class RemoveParentPhoneNumberIdFromPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :phone_numbers, :phone_number, foreign_key: :parent_phone_number_id
  end
end
