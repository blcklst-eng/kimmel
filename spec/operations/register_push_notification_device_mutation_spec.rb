require "rails_helper"

describe "Register Push Notification Device Mutation API", :graphql do
  describe "registerPushNotificationDevice" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: RegisterPushNotificationDeviceInput!) {
          registerPushNotificationDevice(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "registers an address pointing to a device to receive push notifications" do
      fake_adapter = spy(register_device: double)
      stub_const("TwilioNotifyAdapter", fake_adapter)
      user = create(:user)

      result = execute query, as: user, variables: {
        input: {
          address: "testAddress",
          bindingType: "apn",
        },
      }

      success = result[:data][:registerPushNotificationDevice][:success]
      expect(success).to be(true)
      expect(fake_adapter).to have_received(:register_device)
    end
  end
end
