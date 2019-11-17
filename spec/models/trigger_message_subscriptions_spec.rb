require "rails_helper"

RSpec.describe TriggerMessageSubscriptions do
  describe "#call" do
    it "triggers a graphql subscription for messageReceived" do
      schema = stub_const("MessagingSchema", spy)
      message = build_stubbed(:incoming_message)

      described_class.new(message).call

      expect(schema).to have_received(:trigger).with("messageReceived", any_args).twice
    end

    it "triggers a graphql subscription for messageSent" do
      schema = stub_const("MessagingSchema", spy)
      message = build_stubbed(:outgoing_message)

      described_class.new(message).call

      expect(schema).to have_received(:trigger).with("messageSent", any_args).twice
    end
  end
end
