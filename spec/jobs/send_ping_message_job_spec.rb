require "rails_helper"

RSpec.describe SendPingMessageJob, type: :job do
  describe "#perform" do
    it "sends a message" do
      fake_adapter = spy(TwilioAdapter)
      expect(fake_adapter).to receive(:new)

      phone_number = create(:phone_number)
      expect(fake_adapter).to receive(:send_message).with(
        to: "+18084004547",
        body: "Ping Message",
        from: phone_number.number
      )

      stub_const("TwilioAdapter", fake_adapter)

      described_class.perform_now phone_number
    end
  end
end
