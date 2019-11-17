require "rails_helper"

RSpec.describe RegisterPushNotificationDeviceForUser do
  describe "#call" do
    it "binds a device to a user" do
      user = double(id: 1)
      notify = double(register_device: double)

      result = described_class.new(user, notify: notify).call(address: "1234", type: "apn")

      expect(result.success?).to eq(true)
    end

    it "returns an error if the device fails to bind" do
      user = double(id: 1)
      notify = double(register_device: false)

      result = described_class.new(user, notify: notify).call(address: "1234", type: "apn")

      expect(result.success?).to eq(false)
    end
  end
end
