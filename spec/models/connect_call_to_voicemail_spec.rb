require "rails_helper"

RSpec.describe ConnectCallToVoicemail do
  describe "#call" do
    it "connects the participants of a call to voicemail" do
      call = build_stubbed(:incoming_call, :with_participant)
      adapter = spy(update_call: true)

      result = described_class.new(
        incoming_call: call,
        adapter: adapter
      ).call

      expect(result.success?).to be(true)
      expect(adapter).to have_received(:update_call).with(hash_including(sid: call.from_sid))
    end

    it "returns a failure if the connection fails" do
      call = spy
      adapter = spy(update_call: false)

      result = described_class.new(
        incoming_call: call,
        adapter: adapter
      ).call

      expect(result.success?).to be(false)
    end
  end
end
