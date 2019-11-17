require "rails_helper"

RSpec.describe PublishPushNotificationsForMessage do
  describe "#call" do
    it "publishes a message to a device" do
      user = build(:user)
      contact = double(identity: "John Doe")
      message = double(
        user_id: user.id,
        user: user,
        contact: contact,
        conversation_id: 1,
        body: "test"
      )
      client = double(send: true)

      result = described_class.new(message, client: client).call

      expect(result).to eq(true)
    end
  end
end
