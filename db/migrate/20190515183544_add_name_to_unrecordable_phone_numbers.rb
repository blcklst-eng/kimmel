class AddNameToUnrecordablePhoneNumbers < ActiveRecord::Migration[6.0]
  def change
    add_column :unrecordable_phone_numbers, :name, :string
  end
end
