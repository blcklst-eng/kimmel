require "rails_helper"

RSpec.describe ConnectCall do
  describe "#call" do
    it "tells the twilio adapter to create a call" do
      call = build_stubbed(:incoming_call)
      spy = spy(create_call: CallResult.new(connected?: true, sid: "123"))
      adapter = stub_const("TwilioAdapter", spy)

      result = described_class.new(
        call: call,
        to: "client:1",
        from: "+15005550006",
        adapter: adapter
      ).call

      expect(result.success?).to be(true)
      expect(result.sid).not_to be(nil)
      expect(spy).to have_receieved(:create_call)
    end

    it "does not call if there is a problem" do
      call = build_stubbed(:incoming_call)
      adapter = double(create_call: CallResult.new(connected?: false))

      result = described_class.new(
        call: call,
        to: "client:1",
        from: "+15005550001",
        adapter: adapter
      ).call

      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end
  end
end
