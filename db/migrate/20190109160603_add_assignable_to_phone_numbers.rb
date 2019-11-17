class AddAssignableToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_reference :phone_numbers, :assignable, polymorphic: true

    add_index :phone_numbers,
      [:assignable_id, :assignable_type],
      unique: true,
      where: "forwarding = false"
  end
end
