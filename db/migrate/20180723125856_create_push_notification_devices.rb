class CreatePushNotificationDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :push_notification_devices do |t|
      t.references :user, foreign_key: true
      t.string :token, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
      t.index :token, unique: true
    end
  end
end
